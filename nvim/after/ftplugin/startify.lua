-- vim.opt_local doesn't work as setlocal in this case
vim.cmd('setlocal cursorline')
require('seblj.utils').setup_hidden_cursor()
vim.g.startify_change_to_dir = 0
