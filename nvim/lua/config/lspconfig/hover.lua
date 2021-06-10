local M = {}
local ui = require('seblj.utils.ui')

M.handler = function(_, method, result, _, _, config)
    config = config or {}
    config.focus_id = method
    if not (result and result.contents) then
        return
    end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
        return
    end
    config = vim.tbl_extend('keep', config, {
        syntax = 'markdown',
        lines = markdown_lines,
    })
    return ui.popup_create(config)
end

return M
