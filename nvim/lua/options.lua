---------- OPTIONS ----------
local utils = require('utils')
local cmd, g, opt = vim.cmd, vim.g, utils.opt

cmd('colorscheme sonokai')
cmd('filetype plugin indent on')

opt('o', 'splitbelow', true)
opt('o', 'splitright', true)
opt('o', 'updatetime', 250)
opt('o', 'cmdheight', 2)
opt('o', 'clipboard', 'unnamedplus')
opt('o', 'mouse', 'a')
opt('b', 'tabstop', 4)
opt('b', 'expandtab', true)
opt('b', 'softtabstop', 4)
opt('b', 'shiftwidth', 4)
opt('b', 'swapfile', false)
opt('w', 'number', true)
opt('w', 'relativenumber', true)
opt('w', 'foldmethod', 'indent')
opt('o', 'foldlevelstart', 20)
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)
opt('o', 'termguicolors', true)
opt('b', 'undofile', true)
opt('o', 'undolevels', 1000)
opt('o', 'shortmess', vim.o.shortmess .. 'c')

cmd([[autocmd FileType * setlocal formatoptions-=o formatoptions+=r]])
cmd([[autocmd BufRead,BufNewFile .gitignore_global set ft=gitignore]])
cmd([[autocmd BufRead,BufNewFile .gitconfig.local set ft=gitconfig]])
cmd([[autocmd BufRead,BufNewFile * if &filetype ==# '' | setlocal spell | endif]])

g.vimsyn_embed = 'l'
g.python3_host_prog = '/usr/local/bin/python3.8'
