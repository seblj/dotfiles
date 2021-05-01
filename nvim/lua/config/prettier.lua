---------- PRETTIER CONFIG ----------

local utils = require('seblj.utils')
local map, cmd = utils.map, vim.cmd

map('n', '<leader>p', ':PrettierAsync<CR>')
cmd([[let g:prettier#quickfix_enabled = 0]])
cmd([[autocmd BufWritePre *.tsx,*.ts PrettierAsync]])
