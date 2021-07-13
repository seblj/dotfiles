local autocmd = require('seblj.utils').autocmd
autocmd({
    event = { 'BufRead', 'BufNewFile' },
    pattern = '*.fs',
    command = function()
        vim.opt.ft = 'fsharp'
    end,
})
