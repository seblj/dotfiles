---------- TREESITTER CONFIG ----------

vim.treesitter.language.register("bash", "zsh")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end
        -- TODO: Maybe add indent if an indents.scm file exist. Currently
        -- this doesn't work if no indents.scm file exists.

        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
