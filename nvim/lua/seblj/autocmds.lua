---------- AUTOCMDS ----------

local group = vim.api.nvim_create_augroup("SebGroup", { clear = true })
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

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "bigfile",
    callback = function(ev)
        vim.notify("Big file detected")

        local ft = vim.filetype.match({ buf = ev.buf }) or ""
        vim.schedule(function()
            vim.bo[ev.buf].syntax = ft
        end)
    end,
})
