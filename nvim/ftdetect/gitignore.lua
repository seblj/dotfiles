local autocmd = require('seblj.utils').autocmd
autocmd({
    event = { 'BufRead', 'BufNewFile' },
    pattern = '.gitignore_global',
    command = function()
        vim.opt.ft = 'gitignore'
    end,
})
