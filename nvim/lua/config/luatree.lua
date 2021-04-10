---------- LUATREE CONFIG ----------

local utils = require('seblj.utils')
local g, map = vim.g, utils.map

g.nvim_tree_icons = {
    default = ''
}
g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '.DS_Store' }
g.nvim_tree_git_hl = 1
-- g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
-- g.nvim_tree_auto_open = 1

map('n', '<leader>tt', ':NvimTreeToggle<CR>')

g.nvim_tree_bindings = {
    ["r"] = ':lua require("nvim-tree").on_keypress("full_rename")<CR>',
    ["<C-r>"] = ':lua require("nvim-tree").on_keypress("rename")<CR>'
}
