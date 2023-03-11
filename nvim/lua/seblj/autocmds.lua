---------- AUTOCMDS ----------

-- Avoid nesting neovim sessions
vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
local group = vim.api.nvim_create_augroup("SebGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "gitcommit", "gitrebase", "gitconfig" },
    callback = function()
        vim.bo.bufhidden = "delete"
    end,
    desc = "Set bufhidden to delete",
})

vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "tex", "markdown" },
    group = group,
    callback = function()
        vim.opt_local.spell = true
    end,
    desc = "Set spell",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "html", "javascript", "typescript", "typescriptreact", "javascriptreact", "css", "vue" },
    group = group,
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
    desc = "2 space indent",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - "t"
    end,
    desc = "Remove auto-wrap text using textwidth",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - "o" + "r" + "c"
    end,
    desc = "Fix formatoptions",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
        local text = vim.fn.getreg(vim.v.event.regname)
        local data = require("seblj.utils").get_os_command_output("base64", { writer = text })
        io.stderr:write(string.format("\x1b]52;c;%s\x07", table.concat(data)))
    end,
    desc = "Highlight on yank",
})
