return {
    "lervag/vimtex",
    config = function()
        vim.g.vimtex_quickfix_mode = 0
        vim.g.vimtex_syntax_enabled = 0
        vim.g.vimtex_view_method = vim.fn.has("mac") == 1 and "skim" or "zathura"

        -- Clean latex files when quitting
        vim.api.nvim_create_autocmd("User", {
            group = vim.api.nvim_create_augroup("VimtexConfig", { clear = true }),
            pattern = "VimtexEventQuit",
            callback = function()
                vim.cmd.VimtexClean()
            end,
            desc = "Clean up latex files",
        })
    end,
    ft = { "tex", "bib" },
}
