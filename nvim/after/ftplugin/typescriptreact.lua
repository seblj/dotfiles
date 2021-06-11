local utils = require('seblj.utils')
local map = utils.map

vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

map('i', '<C-c>', '<Esc>T<"iyiw$a</<ESC>"ipa><ESC>F<i')
