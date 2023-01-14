local keymap = vim.keymap.set

local options = {
    prefix = " ",
    border_line = "─",
}

local function set_close_mappings()
    keymap("n", "<ESC>", function()
        vim.api.nvim_win_close(0, true)
    end, {
        buffer = true,
        desc = "Close popup",
    })
    keymap("n", "q", function()
        vim.api.nvim_win_close(0, true)
    end, {
        buffer = true,
        desc = "Close popup",
    })
end

local function confirm(items, on_choice, key)
    local choice = tonumber(vim.fn.expand("<cword>"))
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
            items = { items, "table", false },
            on_choice = { on_choice, "function", false },
        })
        opts = opts or {}
        local choices = {}
        local format_item = opts.format_item or tostring
        for i, item in pairs(items) do
            table.insert(choices, string.format("[%d] %s", i, format_item(item)))
        end

        local width = 0
        for _, line in ipairs(choices) do
            width = math.max(vim.fn.strdisplaywidth(line), width)
        end
        local title = opts.prompt or "Select one of:"
        local lines = { title, string.rep(options.border_line, width), unpack(choices) }

        local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, opts.syntax, {
            border = CUSTOM_BORDER,
        })

        vim.api.nvim_set_current_win(winnr)
        set_close_mappings()

        require("seblj.utils").setup_hidden_cursor()
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = vim.api.nvim_create_augroup("UISetCursor", { clear = true }),
            pattern = "<buffer>",
            callback = function()
                local current_line = vim.fn.line(".")
                local max_lines = vim.api.nvim_buf_line_count(0)
                if current_line < 3 and max_lines >= 3 then
                    vim.api.nvim_win_set_cursor(0, { 3, 1 })
                end
            end,
            desc = "Hidden cursor",
        })

        keymap({ "i", "n" }, "<CR>", function()
            confirm(items, on_choice)
            vim.cmd.stopinsert()
        end, {
            buffer = true,
            desc = "Confirm selection",
        })

        vim.api.nvim_win_set_cursor(winnr, { math.ceil(#title / width) + 2, 1 })
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, "Title", 0, 0, #title)
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, "NormalFloat", 1, 0, -1)

        for k, _ in ipairs(choices) do
            if k > 1 then
                keymap("n", string.format("%d", k - 1), function()
                    confirm(items, on_choice, k - 1)
                end, {
                    buffer = true,
                    desc = "Select option with number",
                })
            end
        end
    end)
end

-- Override vim.ui.input to use popup
vim.ui.input = function(opts, on_confirm)
    vim.schedule(function()
        vim.validate({
            on_confirm = { on_confirm, "function", false },
        })
        opts = opts or {}

        local width = 30
        local lines = { opts.prompt, string.rep(options.border_line, width), unpack({ opts.prompt }, 2) }

        local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, opts.syntax, {
            max_width = 50,
            border = CUSTOM_BORDER,
            height = math.ceil(#opts.prompt / width) + 2,
        })

        vim.wo[winnr].winhl = "Normal:NormalFloat"
        vim.api.nvim_set_current_win(winnr)

        set_close_mappings()

        keymap({ "i", "n" }, "<CR>", function()
            local input = vim.trim(vim.fn.getline("."):sub(#options.prefix + 1, -1))
            vim.api.nvim_win_close(0, true)
            on_confirm(input)
            vim.cmd.stopinsert()
        end, {
            buffer = true,
            desc = "Confirm selection",
        })

        vim.cmd.startinsert()
        vim.bo[popup_bufnr].modifiable = true
        vim.bo[popup_bufnr].buftype = "prompt"
        vim.fn.prompt_setprompt(popup_bufnr, options.prefix)
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, "Title", 0, 0, #lines[1])
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, "NormalFloat", 1, 0, -1)
    end)
end
