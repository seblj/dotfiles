---------- PRETTIER CONFIG ----------

local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap

nnoremap({ '<leader>p', ':PrettierAsync<CR>' })
vim.cmd([[let g:prettier#quickfix_enabled = 0]])
vim.cmd([[autocmd BufWritePre *.tsx,*.ts PrettierAsync]])
