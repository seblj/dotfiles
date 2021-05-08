---------- GITSIGNS CONFIG ----------

local utils = require('seblj.utils')
local map = utils.map

require('gitsigns').setup {
    signs = {
        add = {hl = 'GitGutterAdd'   , text = '+'},
        change = {hl = 'GitGutterChange', text = '~'},
        delete = {hl = 'GitGutterDelete', text = '_'},
        topdelete = {hl = 'GitGutterDelete', text = '‾'},
        changedelete = {hl = 'GitGutterChangeDelete', text = '~_'},
    },
    use_decoration_api = false,
    max_file_length = 200000,
    keymaps = {},
}

map('n', '<leader>gm', '<cmd>Gitsigns blame_line<CR>')
map('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>')
map('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>')
map('n', '<leader>gd', '<cmd>Gitsigns preview_hunk<CR>')
map('n', '<leader>grh', '<cmd>Gitsigns reset_hunk<CR>')
map('n', '<leader>grb', '<cmd>Gitsigns reset_buffer<CR>')
