local M = {}

M.border_line = '─'

M.calculate_width = function(lines)
    local max_width = math.ceil(vim.o.columns * 0.8)
    local max_length = 0
    for _, line in pairs(lines) do
        if #line > max_length then
            max_length = #line
        end
    end
    return max_length <= max_width and max_length or max_width
end

M.set_cursor = function()
    local current_line = vim.fn.line('.')
    local max_lines = vim.api.nvim_buf_line_count(0)
    if current_line < 3 and max_lines >= 3 then
        vim.api.nvim_win_set_cursor(0, { 3, 1 })
    end
end

M.popup_create = function(opts)
    local lines, syntax = opts.lines or {}, opts.syntax
    opts.border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    opts.border = 'rounded'
    local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, syntax, opts)

    vim.api.nvim_win_set_option(winnr, 'winhl', 'Normal:Normal')
    if opts.enter then
        vim.api.nvim_set_current_win(winnr)
        vim.api.nvim_buf_set_keymap(
            popup_bufnr,
            'n',
            '<ESC>',
            '<cmd>lua vim.api.nvim_win_close(0, true)<CR>',
            { silent = true }
        )
    end
    if opts.prompt and opts.prompt.enable then
        vim.api.nvim_buf_set_option(popup_bufnr, 'buftype', 'prompt')
        vim.fn.prompt_setprompt(popup_bufnr, opts.prompt.prefix)
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, opts.prompt.highlight, #lines, 0, #opts.prompt.prefix)
        vim.api.nvim_buf_set_option(popup_bufnr, 'ft', 'UIPrompt')
    end

    return popup_bufnr, winnr
end

return M
