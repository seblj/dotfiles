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

vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, buf)
                return vim.bo[buf]
                        and vim.bo[buf].filetype ~= "bigfile"
                        and path
                        and vim.fn.getfsize(path) > 1.5 * 1024 * 1024
                        and "bigfile"
                    or nil
            end,
        },
    },
})
