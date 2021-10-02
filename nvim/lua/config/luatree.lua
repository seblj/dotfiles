---------- LUATREE CONFIG ----------

local tree_cb = require('nvim-tree.config').nvim_tree_callback
local nnoremap = vim.keymap.nnoremap

require('nvim-tree').setup({
    view = {
        mappings = {
            list = {
                { key = 'r', cb = tree_cb('full_rename') },
                { key = '<C-r>', cb = tree_cb('rename') },
                { key = 'J', cb = ":exe 'normal 10j'<CR>" },
                { key = 'K', cb = ":exe 'normal 10k'<CR>" },
                { key = 'dd', cb = tree_cb('remove') },
                { key = '..', cb = tree_cb('dir_up') },
            },
        },
    },
})

vim.g.nvim_tree_icons = {
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

vim.g.nvim_tree_special_files = {
    {
        ['Cargo.toml'] = false,
        Makefile = false,
        ['README.md'] = false,
        ['readme.md'] = false,
    },
}

vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '.DS_Store' }

nnoremap({ '<leader>tt', ':NvimTreeToggle<CR>' })
