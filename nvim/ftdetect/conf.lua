local augroup = require('seblj.utils').augroup
augroup('ConfDetect', {
    event = { 'BufRead', 'BufNewFile' },
    pattern = '*.conf',
    command = function()
        vim.opt.ft = 'conf'
    end,
})
