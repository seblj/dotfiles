---------- AUTOCMDS ----------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Avoid nesting neovim sessions
vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
local group = augroup("SebGroup", { clear = true })
autocmd("FileType", {
    group = group,
    pattern = { "gitcommit", "gitrebase", "gitconfig" },
    callback = function()
        vim.bo.bufhidden = "delete"
    end,
    desc = "Set bufhidden to delete",
})

autocmd("VimResized", {
    group = group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

autocmd("FileType", {
    pattern = { "text", "tex", "markdown" },
    group = group,
    callback = function()
        vim.opt_local.spell = true
    end,
    desc = "Set spell",
})

autocmd("FileType", {
    pattern = { "json", "html", "javascript", "typescript", "typescriptreact", "javascriptreact", "css", "vue" },
    group = group,
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
    desc = "2 space indent",
})

autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - "t"
    end,
    desc = "Remove auto-wrap text using textwidth",
})

autocmd("FileType", {
    group = group,
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - "o" + "r" + "c"
    end,
    desc = "Fix formatoptions",
})

autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
        if vim.env.SSH_CONNECTION then
            -- See if I should get from another register
            local ok, yank_data = pcall(vim.fn.getreg, "0")
            if ok and #yank_data > 0 then
                local Job = require("plenary.job")
                local data = nil
                Job:new({
                    command = "base64",
                    writer = yank_data,
                    on_exit = function(j, _)
                        data = table.concat(j:result())
                    end,
                }):sync()
                vim.fn.chansend(vim.v.stderr, string.format("\x1b]52;c;%s\x07", data))
            end
        end
    end,
    desc = "Highlight on yank",
})
