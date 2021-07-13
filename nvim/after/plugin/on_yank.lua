local augroup = require('seblj.utils').augroup
augroup('HighlightYank', {
    event = 'TextYankPost',
    pattern = '*',
    modifier = 'silent!',
    command = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
    end,
})
