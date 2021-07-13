local autocmd = require('seblj.utils').autocmd
autocmd({
    event = { 'BufRead', 'BufNewFile' },
    pattern = '*.http',
    command = function()
        vim.opt.ft = 'http'
    end,
})
