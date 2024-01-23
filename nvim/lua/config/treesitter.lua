---------- TREESITTER CONFIG ----------

vim.treesitter.language.register("bash", "zsh")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
