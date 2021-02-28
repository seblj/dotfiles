---------- TAGS CONFIG ----------

local utils = require'utils'
local g, map = vim.g, utils.map

g.gutentags_ctags_tagfile = '.tags'
g.gutentags_exclude_filetypes = {'sh', 'vim'}

map('n', 'gd', '<C-]>')
map('v', 'gd', '<C-]>')

map('n', 'gb', '<C-t>')
map('v', 'gb', '<C-t>')
