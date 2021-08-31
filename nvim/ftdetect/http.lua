local augroup = require('seblj.utils').augroup
augroup('HTTPDetect', {
    event = { 'BufRead', 'BufNewFile' },
    pattern = '*.http',
    command = function()
        vim.opt.ft = 'http'
    end,
})
