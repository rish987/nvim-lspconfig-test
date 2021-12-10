local a = require("plenary.async")
local helpers = require("test.helpers")
require("test.extensions")

local it = a.tests.it

describe("powershell_es", function()
  helpers.setup_server("powershell_es", {
    root_dir = function()
      return vim.loop.cwd()
    end,
  })

  it("starts", function()
    vim.api.nvim_command("bufdo bwipeout!")
    vim.api.nvim_command("new | only | silent edit fixtures/example-project-1/index.ps1")
    vim.api.nvim_command("set ft=ps1")
    helpers.wait_for_ready_lsp()

    local buf_clients = vim.lsp.buf_get_clients()

    assert.equal(1, #buf_clients)
    assert.equal("powershell_es", buf_clients[1].name)
    assert.is_truthy(buf_clients[1].initialized)
  end)
end)
