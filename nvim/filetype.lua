vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("TermDetect", { clear = true }),
    pattern = "term://*",
    callback = function()
        vim.opt.ft = "term"
        vim.cmd("$")
        vim.cmd.startinsert()
    end,
    desc = "Set filetype for term buffer",
})
