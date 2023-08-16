--lua/code_action_utils.lua
local M = {}
local vim = vim

local lsp_util = vim.lsp.util

function M.code_action_listener()
  local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local params = lsp_util.make_range_params()
  params.context = context
  local currentLineNum, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx, config)
    -- do something with result - e.g. check if empty and show some indication such as a sign
  end)
end

return M
