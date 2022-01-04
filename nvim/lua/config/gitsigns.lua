---------- GITSIGNS CONFIG ----------

local keymap = vim.keymap.set

require('gitsigns').setup({
    signs = {
        add = { hl = 'GitGutterAdd', text = '+' },
        change = { hl = 'GitGutterChange', text = '~' },
        delete = { hl = 'GitGutterDelete', text = '_' },
        topdelete = { hl = 'GitGutterDelete', text = '‾' },
        changedelete = { hl = 'GitGutterChangeDelete', text = '~_' },
    },
    preview_config = {
        border = 'rounded',
    },
    max_file_length = 200000,
})

keymap('n', '<leader>gm', '<cmd>Gitsigns blame_line<CR>', { desc = 'Gitsigns: Git blame current line' })
keymap('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>', { desc = 'Gitsigns: Go to next diff hunk' })
keymap('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'Gitsigns: Go to previous diff hunk' })
keymap('n', '<leader>gd', '<cmd>Gitsigns preview_hunk<CR>', { desc = 'Gitsigns: Preview diff hunk' })
keymap('n', '<leader>grh', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Gitsigns: Reset diff hunk over cursor' })
keymap('n', '<leader>grb', '<cmd>Gitsigns reset_buffer<CR>', { desc = 'Gitsigns: Reset diff for entire buffer' })
