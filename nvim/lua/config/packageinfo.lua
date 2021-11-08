local utils = require('seblj.utils.keymap')
local nnoremap = utils.nnoremap

require('package-info').setup()

nnoremap({
    '<leader>nu',
    function()
        require('package-info').update()
        require('seblj.utils').setup_hidden_cursor()
    end,
})
nnoremap({
    '<leader>nd',
    function()
        require('package-info').delete()
        require('seblj.utils').setup_hidden_cursor()
    end,
})
nnoremap({
    '<leader>ni',
    function()
        require('package-info').install()
        require('seblj.utils').setup_hidden_cursor()
    end,
})
nnoremap({
    '<leader>nv',
    function()
        require('package-info').change_version()
        require('seblj.utils').setup_hidden_cursor()
    end,
})
