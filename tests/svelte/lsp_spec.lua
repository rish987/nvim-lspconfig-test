local a = require("plenary.async")
local helpers = require("test.helpers")
require("test.extensions")

local it = a.tests.it

describe("svelte", function()
  helpers.setup_server("svelte", {})

  it("starts", function()
    vim.api.nvim_command("bufdo bwipeout!")
    vim.api.nvim_command("new | only | silent edit fixtures/example-project-1/app.svelte")
    vim.api.nvim_command("set ft=svelte")
    helpers.wait_for_ready_lsp()

    local buf_clients = vim.lsp.buf_get_clients()

    assert.equal(1, #buf_clients)
    assert.equal("svelte", buf_clients[1].name)
    assert.is_truthy(buf_clients[1].initialized)
  end)
end)
