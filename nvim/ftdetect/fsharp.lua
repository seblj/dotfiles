local augroup = require('seblj.utils').augroup
augroup('FsharpDetect', {
    event = { 'BufRead', 'BufNewFile' },
    pattern = '*.fs',
    command = function()
        vim.opt.ft = 'fsharp'
    end,
})
