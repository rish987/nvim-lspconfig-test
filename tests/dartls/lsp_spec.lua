local a = require("plenary.async")
local helpers = require("test.helpers")
require("test.extensions")

local it = a.tests.it

describe("dartls", function()
  helpers.setup_server("dartls", {})

  it("starts", function()
    vim.api.nvim_command("bufdo bwipeout!")
    vim.api.nvim_command("new | only | silent edit fixtures/example-project-1/index.dart")
    vim.api.nvim_command("set ft=dart")
    helpers.wait_for_ready_lsp()

    local buf_clients = vim.lsp.buf_get_clients()

    assert.equal(1, #buf_clients)
    assert.equal("dartls", buf_clients[1].name)
    assert.is_truthy(buf_clients[1].initialized)
  end)
end)
