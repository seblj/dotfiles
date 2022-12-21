vim.opt.guicursor = vim.opt.guicursor + 'a:Cursor/lCursor'
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
vim.opt_local.cursorline = false

vim.keymap.set('n', 'gd', 'K', { remap = true })
vim.keymap.del('n', 'K')
vim.keymap.set('n', 'K', '10gk')
