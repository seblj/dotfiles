local utils = require('utils')
local map = utils.map

map('n', '<leader>gl', 'd3o', {noremap = false})
map('n', '<leader>gh', 'd2o', {noremap = false})
map('n', '<leader>gd', ':Gdiffsplit!<CR>')
