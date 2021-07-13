local autocmd = require('seblj.utils').autocmd
autocmd({
    event = { 'BufRead', 'BufNewFile' },
    pattern = '.gitconfig.local',
    command = function()
        vim.opt.ft = 'gitconfig'
    end,
})
