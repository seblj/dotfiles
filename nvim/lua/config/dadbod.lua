---------- DADBOD ----------

vim.g.db_ui_disable_mappings = 1
vim.g.db_ui_use_nerd_fonts = 1

local group = vim.api.nvim_create_augroup("DadbodMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbui",
    group = group,
    callback = function()
        local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = true
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        map("n", "<CR>", "<Plug>(DBUI_SelectLine)")
        map("n", "R", "<Plug>(DBUI_Redraw)")
        map("n", "d", "<Plug>(DBUI_DeleteLine)")
        map("n", "A", "<Plug>(DBUI_AddConnection)")
        map("n", "H", "<Plug>(DBUI_ToggleDetails)")
        map("n", "r", "<Plug>(DBUI_RenameLine)")
        map("n", "q", "<Plug>(DBUI_Quit)")
    end,
    desc = "Set keymaps for dbui",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql" },
    group = group,
    callback = function()
        require("cmp").setup.buffer({
            sources = {
                { name = "vim-dadbod-completion" },
            },
        })
    end,
    desc = "Register cmd-dadbod source",
})

-- Hack to turn off cursorline in query buffer.
-- Don't understand why this is explicitly turned on in the plugin
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*-query-*",
    group = group,
    callback = function()
        vim.defer_fn(function()
            vim.opt_local.cursorline = false
        end, 50)
    end,
    desc = "Disable cursorline in dbui",
})
