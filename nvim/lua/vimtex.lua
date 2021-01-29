local M = {}

function M.getCompletionItems(prefix)
  -- define your total completion items
  local items = vim.api.nvim_call_function('vimtex#complete#omnifunc', {0, prefix})
  return items
end

M.complete_item = {
  item = M.getCompletionItems
}

return M
