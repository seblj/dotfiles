local ui = require('seblj.utils.ui')
local utils = require('seblj.utils')
local augroup = utils.augroup
local nnoremap = vim.keymap.nnoremap

local confirm = function(items, on_choice, key)
    local choice = tonumber(vim.fn.expand('<cword>'))
    if key then
        choice = key
    end

    vim.api.nvim_win_close(0, true)
    on_choice(items[choice], choice)
end

vim.ui.select = function(items, opts, on_choice)
    vim.validate({
        items = { items, 'table', false },
        on_choice = { on_choice, 'function', false },
    })
    opts = opts or {}
    local choices = { opts.prompt or 'Select one of:' }
    local format_item = opts.format_item or tostring
    for i, item in pairs(items) do
        table.insert(choices, string.format('[%d] %s', i, format_item(item)))
    end

    local title = table.remove(choices, 1)
    local width = ui.calculate_width(choices)
    choices = { title, string.rep(ui.border_line, width), unpack(choices) }

    local popup_bufnr, winnr = ui.popup_create({
        lines = choices,
        enter = true,
    })
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #title)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)
    vim.api.nvim_win_set_cursor(winnr, { 3, 1 })
    vim.api.nvim_win_set_option(winnr, 'cursorline', true)
    require('seblj.utils').setup_hidden_cursor()
    require('seblj.utils').hide_cursor()

    augroup('UISelectInvisibleCursor', {
        event = 'CursorMoved',
        pattern = '<buffer>',
        command = function()
            require('seblj.utils.ui').set_cursor()
        end,
    })

    -- Keymap for selecting option with number
    for k, _ in ipairs(choices) do
        if k > 2 then
            nnoremap({
                string.format('%d', k - 2),
                function()
                    confirm(items, on_choice, k - 2)
                end,
                buffer = true,
            })
        end
    end

    -- stylua: ignore
    nnoremap({ '<CR>', function() confirm(items, on_choice) end, buffer = true })
end
