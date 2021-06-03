---------- OPTIONS ----------
local cmd, g, opt = vim.cmd, vim.g, vim.opt

cmd('colorscheme custom')
cmd('filetype plugin indent on')

opt.splitbelow = true
opt.splitright = true
opt.updatetime = 250
opt.cmdheight = 2
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.tabstop = 4
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.cindent = true
opt.swapfile = false
opt.number = true
opt.relativenumber = true
opt.foldmethod = 'indent'
opt.foldlevelstart = 20
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.undofile = true
opt.undolevels = 1000
opt.shortmess = opt.shortmess + 'c'

cmd([[autocmd FileType * setlocal formatoptions-=o formatoptions+=r]])

g.vimsyn_embed = 'l'
g.python3_host_prog = '/usr/local/bin/python3'
