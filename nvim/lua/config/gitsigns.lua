---------- GITSIGNS CONFIG ----------
require('gitsigns').setup {    
    signs = {
        add = {hl = 'DiffAdd'   , text = '+'},
        change = {hl = 'DiffChange', text = '~'},
        delete = {hl = 'DiffDelete', text = '_'},
        topdelete = {hl = 'DiffDelete', text = '‾'},
        changedelete = {hl = 'DiffChange', text = '~_'},
    },
}

