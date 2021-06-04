local M = {}

local api = vim.api
local ns = api.nvim_create_namespace("lsp_ui")

local border_line = "─"

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
    if current_line < 3 then
        api.nvim_win_set_cursor(0, {3, 1})
    end
end

M.popup_create = function(opts)
    local on_create = opts.on_create
    local buf = api.nvim_create_buf(false, true)
    local width, height
    local lines, title = opts.lines, opts.title
    local enter = opts.enter or false
    if lines and title then
        width = M.calculate_width(lines)
        height = #lines + 2
        lines = { title, string.rep(border_line, width), unpack(lines) }
        api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    else
        width = 30
        height = 1
    end

    local config = vim.lsp.util.make_floating_popup_options(width, height)
    config.border = {
        {"╭", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╮", "FloatBorder"},
        {"│", "FloatBorder"},
        {"╯", "FloatBorder"},
        {"─", "FloatBorder"},
        {"╰", "FloatBorder"},
        {"│", "FloatBorder"}
    }

    local win = api.nvim_open_win(buf, enter, config)
    if opts.prompt and opts.prompt.enable then
        vim.api.nvim_buf_set_option(buf,'buftype','prompt')
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'delete')
        vim.api.nvim_buf_add_highlight(buf, ns, 'LspRenamePrompt', 0, 0, #opts.prompt.prefix)
        vim.fn.prompt_setprompt(buf, opts.prompt.prefix)
    end

    if title then
        api.nvim_buf_add_highlight(buf, ns, 'Title', 0, 0, #title)
        api.nvim_win_set_cursor(win, {3, 1})
    end
    api.nvim_buf_add_highlight(buf, ns, 'FloatBorder', 1, 0, -1)

    api.nvim_win_set_option(win, "winhl","Normal:Normal")
    if opts.limit_cursor then
        api.nvim_command('autocmd CursorMoved <buffer> lua require("config.lspconfig.ui").set_cursor()')
    end
    api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '<cmd>lua vim.api.nvim_win_close(0, true)<CR>', {silent = true})

    if opts.hide_cursor then
        api.nvim_win_set_option(win, 'cursorline', true)
        require('seblj.utils').setup_hidden_cursor()
        require('seblj.utils').hide_cursor()
    end
    if enter then
        vim.bo.modifiable = opts.modifiable or false
    end

    if on_create then
        on_create(buf, win)
    end
    return buf
end

return M
