local M = {}
local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local border_line = '─'

local calculate_width = function(lines)
    local max_width = math.ceil(vim.o.columns * 0.8)
    local max_length = 0
    for _, line in pairs(lines) do
        if #line > max_length then
            max_length = #line
        end
    end
    return max_length <= max_width and max_length or max_width
end

local set_cursor = function()
    local current_line = vim.fn.line('.')
    local max_lines = vim.api.nvim_buf_line_count(0)
    if current_line < 3 and max_lines >= 3 then
        vim.api.nvim_win_set_cursor(0, { 3, 1 })
    end
end

local get_width = function(title, max_width)
    for i = max_width, 30, -1 do
        if string.sub(title, i, i) == ' ' then
            return i
        end
    end
    return max_width
end

M.popup_create = function(opts)
    local lines, syntax = opts.lines or {}, opts.syntax
    local title = lines[1]
    if opts.max_width then
        opts.width = get_width(title, opts.max_width)
    end

    local width = opts.width or calculate_width({ title, lines })
    lines = { title, string.rep(border_line, width), unpack(lines, 2) }

    if opts.prompt then
        opts.height = math.ceil(#title / width) + 2
    end

    opts.border = opts.border or 'rounded'
    local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, syntax, opts)

    vim.api.nvim_win_set_option(winnr, 'winhl', 'Normal:Normal')
    if opts.enter then
        vim.api.nvim_set_current_win(winnr)
        keymap('n', '<ESC>', function()
            vim.api.nvim_win_close(0, true)
        end, {
            buffer = true,
            desc = 'Close popup',
        })
        keymap('n', 'q', function()
            vim.api.nvim_win_close(0, true)
        end, {
            buffer = true,
            desc = 'Close popup',
        })
    end
    if opts.on_confirm then
        keymap('i', '<CR>', function()
            opts.on_confirm()
            vim.cmd('stopinsert')
        end, {
            buffer = true,
            desc = 'Confirm selection',
        })
        keymap('n', '<CR>', function()
            opts.on_confirm()
        end, {
            buffer = true,
            desc = 'Confirm selection',
        })
    end
    if opts.hidden_cursor then
        require('seblj.utils').setup_hidden_cursor()
        augroup({ name = 'UISetCursor' })
        autocmd({
            event = 'CursorMoved',
            pattern = '<buffer>',
            callback = function()
                set_cursor()
            end,
        })
    end
    if opts.prompt then
        vim.cmd('startinsert')
        vim.api.nvim_buf_set_option(popup_bufnr, 'modifiable', true)
        vim.api.nvim_buf_set_option(popup_bufnr, 'buftype', 'prompt')
        vim.fn.prompt_setprompt(popup_bufnr, opts.prompt.prefix)
        vim.api.nvim_buf_set_option(popup_bufnr, 'ft', 'UIPrompt')
    else
        vim.api.nvim_win_set_cursor(winnr, { math.ceil(#title / width) + 2, 1 })
    end

    return popup_bufnr, winnr
end

return M
