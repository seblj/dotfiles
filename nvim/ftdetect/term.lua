local augroup = require('seblj.utils').augroup
augroup('TermDetect', {
    event = 'TermOpen',
    pattern = 'term://*',
    command = function()
        vim.opt.ft = 'term'
    end,
})
