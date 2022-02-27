local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup({ name = 'TermDetect' })
autocmd({
    group = 'TermDetect',
    event = 'TermOpen',
    pattern = 'term://*',
    callback = function()
        vim.opt.ft = 'term'
    end,
})
