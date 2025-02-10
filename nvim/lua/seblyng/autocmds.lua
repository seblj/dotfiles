---------- AUTOCMDS ----------

local group = vim.api.nvim_create_augroup("SebGroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "*",
    callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end

        -- NOTE: These are quite slow if there is a big file
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"

        -- Only enable indentexpr if the lang contains queries for indents
        -- Otherwise it will just mess everything up in C# at least
        local lang = vim.treesitter.language.get_lang(vim.bo.ft) or vim.bo.ft
        if vim.treesitter.query.get(lang, "indents") then
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 })
    end,
    desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("VimResized", { group = group, command = "tabdo wincmd =" })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "text", "tex", "markdown", "gitcommit" },
    command = "setlocal spell",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "json", "html", "javascript", "typescript", "typescriptreact", "javascriptreact", "css", "vue" },
    command = "setlocal tabstop=2 softtabstop=2 shiftwidth=2",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "cs",
    command = "compiler dotnet",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "help",
    command = "nnoremap <buffer> gd K",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "*",
    command = "set formatoptions-=o",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "vue",
    callback = function()
        vim.opt_local.commentstring = "<!-- %s -->"
        vim.opt.formatoptions:remove("r")
    end,
})
