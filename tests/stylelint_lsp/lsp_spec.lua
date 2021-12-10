local a = require("plenary.async")
local helpers = require("test.helpers")
require("test.extensions")

local it = a.tests.it

describe("stylelint_lsp", function()
  helpers.setup_server("stylelint_lsp", {})

  it("starts", function()
    vim.api.nvim_command("bufdo bwipeout!")
    vim.api.nvim_command("new | only | silent edit fixtures/example-project-1/main.css")
    vim.api.nvim_command("set ft=css")
    helpers.wait_for_ready_lsp()

    local buf_clients = vim.lsp.buf_get_clients()

    assert.equal(1, #buf_clients)
    assert.equal("stylelint_lsp", buf_clients[1].name)
    assert.is_truthy(buf_clients[1].initialized)
  end)
end)
