local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('TermDetect', {})
autocmd('TermOpen', {
    group = 'TermDetect',
    pattern = 'term://*',
    callback = function()
        vim.opt.ft = 'term'
    end,
})
