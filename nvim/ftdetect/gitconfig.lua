local augroup = require('seblj.utils').augroup
augroup('GitconfigDetect', {
    event = { 'BufRead', 'BufNewFile' },
    pattern = '.gitconfig.local',
    command = function()
        vim.opt.ft = 'gitconfig'
    end,
})
