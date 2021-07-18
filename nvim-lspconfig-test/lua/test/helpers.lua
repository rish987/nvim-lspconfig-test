local function has_all(_, arguments)
  local text = arguments[1]
  local expected = arguments[2]
  for _, string in pairs(expected) do
    assert.has_match(string, text, nil, true)
  end
  return true
end

assert:register("assertion", "has_all", has_all)

local M = {}

function M.try_lsp_req(pos, method, parser)
  vim.api.nvim_win_set_cursor(0, pos)
  local params = vim.lsp.util.make_position_params()

  local text

  local req_result
  local success, _ = vim.wait(10000, function()
    local results = vim.lsp.buf_request_sync(0, method, params)
    if not results or results[1] and results[1] == nil then return false end

    for _, result in pairs(results) do
      req_result = result.result
    end
    text = parser(req_result)
    if text and text ~= "" then return true end

    return false
  end, 1000)

  return success and text
end

function M.wait_for_ready_lsp()
  local succeeded, _ = vim.wait(20000, vim.lsp.buf.server_ready)
  assert.message("LSP server was never ready.").True(succeeded)
end

function M.definition_parser(result)
  if not result[1] or not type(result[1].targetUri) == "string" then return nil end
  return result[1].targetUri
end

function M.hover_parser(result)
  if not result.contents or not type(result.contents.value) == "string" then return nil end
  return result.contents.value
end

return M
