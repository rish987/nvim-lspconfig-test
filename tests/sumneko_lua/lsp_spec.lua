local a = require("plenary.async")
local helpers = require("test.helpers")
require("test.extensions")

local it = a.tests.it

describe("sumneko_lua", function()
  local is_ready = false
  helpers.setup_server("sumneko_lua", {
    root_dir = function()
      return vim.loop.cwd()
    end,
    handlers = {
      ["$/progress"] = function(_, result)
        is_ready = result and result.value and result.value.kind == "end"
      end,
    },
  })

  before_each(function()
    a.util.block_on(function()
      vim.api.nvim_command("bufdo bwipeout!")
      vim.api.nvim_command("new | only | edit fixtures/example-project-1/init.lua")
      vim.api.nvim_command("set ft=lua")
      helpers.wait_for_ready_lsp()
      while not is_ready do
        a.util.sleep(30)
      end
    end, 5000)
  end)

  describe("acceptance tests", function()
    it("hover", function()
      vim.api.nvim_win_set_cursor(0, { 1, 6 })
      assert.equal(1, #vim.api.nvim_list_wins())
      vim.lsp.buf.hover()
      assert.wait_for(function()
        assert.equal(2, #vim.api.nvim_list_wins())
      end)
      -- Enter preview window
      vim.lsp.buf.hover()
      assert.wait_for(function()
        assert.equal("popup", vim.fn.win_gettype(0))
      end)
      assert.equal([[local string: string = "string"]], vim.api.nvim_buf_get_lines(0, 0, -1, false)[1])
    end)

    it("definition", function()
      vim.api.nvim_win_set_cursor(0, { 4, 20 })
      vim.lsp.buf.definition()
      assert.wait_for(function()
        assert.same({ 1, 6 }, vim.api.nvim_win_get_cursor(0))
      end)
    end)
  end)
end)
