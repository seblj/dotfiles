vim.opt.guicursor = vim.opt.guicursor + 'a:Cursor/lCursor'
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
vim.opt_local.cursorline = false
require('lazy.view').hover = 'gd'

-- Add workaround for issue with startify
vim.defer_fn(function()
    vim.keymap.del('n', 'q', { buffer = true })
    vim.keymap.set('n', 'q', ':q<CR>', { buffer = true })
end, 150)
