---------- NERDCOMMENTER ----------

local utils = require('seblj.utils')
local g, map = vim.g, utils.map

-- Options
g.NERDSpaceDelims = 1
-- g.NERDCommentEmptyLines = 1
g.NERDDefaultAlign = 'left'

-- Language specific option
g.NERDAltDelims_c = 1

-- Mappings
map('n', 'gcc', '<Plug>NERDCommenterToggle', {noremap = false})
map('n', 'gca', '<Plug>NERDCommenterAltDelims', {noremap = false})
map('n', 'gcA', '<Plug>NERDCommenterAppend', {noremap = false})
map('n', 'gcs', '<Plug>NERDCommenterSexy', {noremap = false})
map('n', 'gcm', '<Plug>NERDCommenterMinimal', {noremap = false})
map('n', 'gcy', '<Plug>NERDCommenterYank', {noremap = false, silent = false})
map('n', 'gcL', '<Plug>NERDCommenterToEOL', {noremap = false})
map('v', 'gc', '<Plug>NERDCommenterToggle', {noremap = false})
map('v', 'gy', '<Plug>NERDCommenterYank', {noremap = false})
map('v', 'gs', '<Plug>NERDCommenterSexy', {noremap = false})
map('v', 'gm', '<Plug>NERDCommenterMinimal', {noremap = false})
