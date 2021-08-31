local augroup = require('seblj.utils').augroup
augroup('GitignoreDetect', {
    event = { 'BufRead', 'BufNewFile' },
    pattern = '.gitignore_global',
    command = function()
        vim.opt.ft = 'gitignore'
    end,
})
