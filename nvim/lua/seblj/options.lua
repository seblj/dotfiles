---------- OPTIONS ----------

local utils = require('seblj.utils')
local augroup = utils.augroup

vim.cmd('colorscheme colorscheme')

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 250
vim.opt.cmdheight = 2
vim.opt.inccommand = 'split'
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 20
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.shortmess:append('c')
vim.opt.cinkeys:remove('0#')
vim.opt.fillchars:append('diff:╱')

-- Avoid nesting neovim sessions
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
augroup('NeovimTermGit', {
    event = 'FileType',
    pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
    command = function()
        vim.opt_local.bufhidden = 'delete'
    end,
})

augroup('CustomFormatOptions', {
    event = 'BufEnter',
    pattern = '*',
    command = function()
        vim.opt.formatoptions = vim.opt.formatoptions - 'o' + 'r'
    end,
})

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.vimsyn_embed = 'l'
vim.g.python3_host_prog = '/Users/sebastianlyngjohansen/.pyenv/versions/neovim3/bin/python'

vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
