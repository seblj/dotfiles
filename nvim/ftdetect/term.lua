local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup('TermDetect', {})
autocmd('TermOpen', {
    group = group,
    pattern = 'term://*',
    callback = function()
        vim.opt.ft = 'term'
    end,
})
