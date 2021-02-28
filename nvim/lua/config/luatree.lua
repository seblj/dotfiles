---------- LUATREE CONFIG ----------

local utils = require'utils'
local g, map = vim.g, utils.map

g.nvim_tree_icons = {
    default = ''
}
g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '.DS_Store' }
g.nvim_tree_git_hl = 1

map('n', '<leader>tt', ':NvimTreeToggle<CR>')

g.nvim_tree_bindings = {
    ["r"] = ':lua require"nvim-tree".on_keypress("full_rename")<CR>',
    ["<C-r>"] = ':lua require"nvim-tree".on_keypress("rename")<CR>'
}
