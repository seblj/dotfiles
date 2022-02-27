local ui = require('seblj.utils.ui')
local keymap = vim.keymap.set

local options = {
    prefix = '> ',
}

local confirm = function(items, on_choice, key)
    local choice = tonumber(vim.fn.expand('<cword>'))
    if key then
        choice = key
    end

    vim.api.nvim_win_close(0, true)
    on_choice(items[choice], choice)
end

-- Override vim.ui.select to use popup
vim.ui.select = function(items, opts, on_choice)
    vim.schedule(function()
        vim.validate({
            items = { items, 'table', false },
            on_choice = { on_choice, 'function', false },
        })
        opts = opts or {}
        local choices = {}
        local format_item = opts.format_item or tostring
        for i, item in pairs(items) do
            table.insert(choices, string.format('[%d] %s', i, format_item(item)))
        end

        local title = opts.prompt or 'Select one of:'
        choices = { title, unpack(choices) }

        local popup_bufnr, _ = ui.popup_create({
            lines = choices,
            enter = true,
            hidden_cursor = true,
            on_confirm = function()
                confirm(items, on_choice)
            end,
        })
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #title)
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)

        for k, _ in ipairs(choices) do
            if k > 1 then
                keymap('n', string.format('%d', k - 1), function()
                    confirm(items, on_choice, k - 1)
                end, {
                    buffer = true,
                    desc = 'Select option with number',
                })
            end
        end
    end)
end

-- Override vim.ui.input to use popup
vim.ui.input = function(opts, on_confirm)
    vim.schedule(function()
        vim.validate({
            on_confirm = { on_confirm, 'function', false },
        })
        opts = opts or {}

        local popup_bufnr, _ = ui.popup_create({
            max_width = 50,
            lines = { opts.prompt },
            enter = true,
            prompt = { prefix = options.prefix },
            on_confirm = function()
                local input = vim.trim(vim.fn.getline('.'):sub(#options.prefix + 1, -1))
                vim.api.nvim_win_close(0, true)
                on_confirm(input)
            end,
        })
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #opts.prompt)
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)
    end)
end
