---------- TAGS CONFIG ----------

local g = vim.g
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

g.gutentags_ctags_tagfile = '.tags'
g.gutentags_exclude_filetypes = {'sh', 'vim'}

map('n', 'gd', '<C-]>')
map('v', 'gd', '<C-]>')

map('n', 'gb', '<C-t>')
map('v', 'gb', '<C-t>')
