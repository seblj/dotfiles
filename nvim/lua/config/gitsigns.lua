---------- GITSIGNS CONFIG ----------

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
    keymaps = {
        noremap = true,
        ['n <leader>gm'] = '<cmd>Gitsigns blame_line<CR>',
        ['n <leader>gn'] = '<cmd>Gitsigns next_hunk<CR>',
        ['n <leader>gp'] = '<cmd>Gitsigns prev_hunk<CR>',
        ['n <leader>gd'] = '<cmd>Gitsigns preview_hunk<CR>',
        ['n <leader>grh'] = '<cmd>Gitsigns reset_hunk<CR>',
        ['n <leader>grb'] = '<cmd>Gitsigns reset_buffer<CR>',
    },
})
