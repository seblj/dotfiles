---------- OPTIONS ----------
local utils = require'utils'
local cmd, g, opt, exec = vim.cmd, vim.g, utils.opt, vim.api.nvim_exec

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
opt('o', 'undoreload', 10000)
opt('o', 'shortmess', vim.o.shortmess .. 'c')

cmd([[autocmd FileType * setlocal formatoptions-=o formatoptions+=r]])
cmd([[autocmd BufRead,BufNewFile .gitignore_global set filetype=gitignore]])
cmd([[autocmd BufRead,BufNewFile * if &filetype ==# '' | setlocal spell | endif]])
cmd([[autocmd BufRead,BufNewFile *.h,*.c set filetype=c]])
exec(
[[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
augroup END
]],
false
)


g.vimsyn_embed = 'l'
g.python3_host_prog = '/usr/local/bin/python3.8'
