---------- LUATREE CONFIG ----------

local tree_cb = require('nvim-tree.config').nvim_tree_callback
local utils = require('seblj.utils')
local g, map = vim.g, utils.map

g.nvim_tree_icons = {
    default = '',
    git = {
        unstaged = '!',
        staged = '+',
        unmerged = '=',
        renamed = '»',
        untracked = '?',
        deleted = '✘',
    },
}

g.nvim_tree_special_files = {
    {
        ['Cargo.toml'] = false,
        Makefile = false,
        ['README.md'] = false,
        ['readme.md'] = false,
    },
}

g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '.DS_Store' }
g.nvim_tree_git_hl = 1

map('n', '<leader>tt', ':NvimTreeToggle<CR>')

g.nvim_tree_bindings = {
    { key = 'r', cb = tree_cb('full_rename') },
    { key = '<C-r>', cb = tree_cb('rename') },
    { key = 'J', cb = ":exe 'normal 10j<CR>" },
    { key = 'K', cb = ":exe 'normal 10k<CR>" },
    { key = 'dd', cb = tree_cb('remove') },
    { key = '<CR>', cb = tree_cb('edit') },
}
