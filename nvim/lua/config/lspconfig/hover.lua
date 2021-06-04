local M = {}

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
    vim.api.nvim_win_set_option(0, 'winhl', 'Normal:Normal')
    config.border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}

    return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
end

return M
