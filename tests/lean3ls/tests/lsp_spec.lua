local assert = require('luassert')
local helpers = require('test.helpers')

describe('lean 3', function()
  it('setup', function()
    require('lspconfig').lean3ls.setup({})
  end)

  describe('existing', function()
  describe('nested file', function()
    it('startup', function()
      vim.api.nvim_command("edit fixtures/example-project-1/src/bar/baz.lean")
      vim.api.nvim_command("set ft=lean3")
      helpers.wait_for_ready_lsp()
      assert.equal(1, #vim.lsp.get_active_clients())
    end)

    it('hover', function()
      local text = helpers.try_lsp_req({5, 20}, "textDocument/hover", helpers.hover_parser)
      assert.message("hover request never received parseable data").is_truthy(text)
      assert.has_all_or(text, {{"test : ℕ"}, {"test : nat"}})
    end)

    it('definition', function()
      local text = helpers.try_lsp_req({5, 20}, "textDocument/definition", helpers.definition_parser)
      assert.message("definition request never received parseable data").is_truthy(text)
      -- case-insensitive because MacOS FS is case-insensitive
      assert.has_all(text, {("fixtures/example-project-1/src/foo.lean")})
    end)
  end)

  describe('file', function()
    it('startup', function()
      vim.api.nvim_command("edit fixtures/example-project-1/src/foo.lean")
      vim.api.nvim_command("set ft=lean3")
      helpers.wait_for_ready_lsp()
      assert.equal(1, #vim.lsp.get_active_clients())
    end)

    it('hover', function()
      local text = helpers.try_lsp_req({1, 12}, "textDocument/hover", helpers.hover_parser)
      assert.message("hover request never received parseable data").is_truthy(text)
      assert.has_all_or(text, {{"ℕ : Type"}, {"nat : Type"}})
    end)
  end)
  end)

  -- tests neovim/nvim-lspconfig#1041
  describe('new', function()
  describe('nested file', function()
    it('startup', function()
      vim.api.nvim_command("edit fixtures/example-project-1/src/bar/new_baz.lean")
      vim.api.nvim_command("set ft=lean3")
      helpers.wait_for_ready_lsp()
      vim.api.nvim_command("0read fixtures/example-project-1/src/bar/baz.lean")
      assert.equal(1, #vim.lsp.get_active_clients())
    end)

    it('hover', function()
      local text = helpers.try_lsp_req({5, 20}, "textDocument/hover", helpers.hover_parser)
      assert.message("hover request never received parseable data").is_truthy(text)
      assert.has_all_or(text, {{"test : ℕ"}, {"test : nat"}})
    end)

    it('definition', function()
      local text = helpers.try_lsp_req({5, 20}, "textDocument/definition", helpers.definition_parser)
      assert.message("definition request never received parseable data").is_truthy(text)
      assert.has_all(text, {("fixtures/example-project-1/src/foo.lean")})
    end)
  end)
  describe('file', function()
    it('startup', function()
      vim.api.nvim_command("edit! fixtures/example-project-1/src/new_foo.lean")
      vim.api.nvim_command("set ft=lean3")
      helpers.wait_for_ready_lsp()
      vim.api.nvim_command("0read fixtures/example-project-1/src/foo.lean")
      assert.equal(1, #vim.lsp.get_active_clients())
    end)

    it('hover', function()
      local text = helpers.try_lsp_req({1, 12}, "textDocument/hover", helpers.hover_parser)
      assert.message("hover request never received parseable data").is_truthy(text)
      assert.has_all_or(text, {{"ℕ : Type"}, {"nat : Type"}})
    end)
  end)
  end)

  describe('second project', function()
    it('startup', function()
      vim.api.nvim_command("edit! fixtures/example-project-2/src/bar/baz.lean")
      vim.api.nvim_command("set ft=lean3")
      helpers.wait_for_ready_lsp()
      assert.equal(2, #vim.lsp.get_active_clients())
    end)

    it('hover', function()
      local text = helpers.try_lsp_req({5, 21}, "textDocument/hover", helpers.hover_parser)
      assert.message("hover request never received parseable data").is_truthy(text)
      assert.has_all(text, {"test : Prop"})
    end)

    it('definition', function()
      local text = helpers.try_lsp_req({5, 21}, "textDocument/definition", helpers.definition_parser)
      assert.message("definition request never received parseable data").is_truthy(text)
      assert.has_all(text, {("fixtures/example-project-2/src/foo.lean")})
    end)
  end)

  -- It seems this isn't supported by Lean 4 at the moment?
  describe('standalone file', function()
    vim.api.nvim_command('!elan default "leanprover-community/lean:3.30.0"')
    it('startup', function()
      vim.api.nvim_command("edit /tmp/foo.lean")
      vim.api.nvim_command("set ft=lean3")
      helpers.wait_for_ready_lsp()
      vim.api.nvim_command("0read fixtures/example-project-1/src/foo.lean")
      assert.equal(3, #vim.lsp.get_active_clients())
    end)

    it('hover', function()
      local text = helpers.try_lsp_req({1, 12}, "textDocument/hover", helpers.hover_parser)
      assert.message("hover request never received parseable data").is_truthy(text)
      assert.has_all_or(text, {{"ℕ : Type"}, {"nat : Type"}})
    end)
  end)
end)
