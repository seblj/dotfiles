local M = {}
local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local border_line = '─'

local calculate_width = function(opts, lines)
    local width = opts.width
    local max_width = opts.max_width
    local min_width = opts.min_width or 0
    local line_widths = {}

    if not width then
        width = 0
        for i, line in ipairs(lines) do
            line_widths[i] = vim.fn.strdisplaywidth(line)
            width = math.max(line_widths[i], width)
        end
    end

    local screen_width = vim.api.nvim_win_get_width(0)
    if width < min_width then
        width = min_width
    end
    width = math.min(width, screen_width)

    if max_width then
        width = math.min(width, max_width)
    end
    return width
end

local set_cursor = function()
    local current_line = vim.fn.line('.')
    local max_lines = vim.api.nvim_buf_line_count(0)
    if current_line < 3 and max_lines >= 3 then
        vim.api.nvim_win_set_cursor(0, { 3, 1 })
    end
end

M.popup_create = function(opts)
    local lines, syntax = opts.lines or {}, opts.syntax
    local title = lines[1]

    local width = calculate_width(opts, lines)
    lines = { title, string.rep(border_line, width), unpack(lines, 2) }

    if opts.prompt then
        opts.height = math.ceil(#title / width) + 2
    end

    opts.border = opts.border or CUSTOM_BORDER
    local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, syntax, opts)

    vim.api.nvim_win_set_option(winnr, 'winhl', 'Normal:NormalFloat')
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
            vim.cmd.stopinsert()
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
        local group = augroup('UISetCursor', {})
        autocmd('CursorMoved', {
            group = group,
            pattern = '<buffer>',
            callback = function()
                set_cursor()
            end,
        })
    end
    if opts.prompt then
        vim.cmd.startinsert()
        vim.api.nvim_buf_set_option(popup_bufnr, 'modifiable', true)
        vim.api.nvim_buf_set_option(popup_bufnr, 'buftype', 'prompt')
        vim.fn.prompt_setprompt(popup_bufnr, opts.prompt.prefix)
        vim.api.nvim_buf_set_option(popup_bufnr, 'ft', 'UIPrompt')
    else
        vim.api.nvim_win_set_cursor(winnr, { math.ceil(#title / width) + 2, 1 })
    end

    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #title)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'NormalFloat', 1, 0, -1)

    return popup_bufnr, winnr
end

return M
