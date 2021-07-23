local function has_all(_, arguments)
  local text = arguments[1]
  local expected = arguments[2]
  for _, string in pairs(expected) do
    assert.has_match(string, text, nil, true)
  end
  return true
end

local function has_all_or(_, arguments)
  local text = arguments[1]
  local expecteds = arguments[2]
  local found = false

  for _, expected in pairs(expecteds) do
    local found_this = true
    for _, this_string in pairs(expected) do
      if not string.find(text, this_string, nil, true) then
        found_this = false
      end
    end
    if found_this then found = true break end
  end
  assert.message("expected one of: \n" .. vim.inspect(expecteds) .. "\nbut got:\n" .. text).is_true(found)
  return found
end

assert:register("assertion", "has_all", has_all)
assert:register("assertion", "has_all_or", has_all_or)

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

-- follows the implementation of `location_handler()` from lua/vim/lsp/handlers.lua
function M.definition_parser(result)
  if not result then return nil end

  local def_list = {}
  if vim.tbl_islist(result) then
    for _, this_result in pairs(result) do
      local uri = this_result.uri or this_result.targetUri
      if uri then table.insert(def_list, uri) end
    end
  else
    local uri = result.uri or result.targetUri
    if uri then table.insert(def_list, uri) end
  end

  if #def_list == 0 then return nil end

  return table.concat(def_list, "\n")
end

function M.hover_parser(result)
  if not (result and result.contents) then return nil end
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  return table.concat(markdown_lines, "\n")
end

return M
