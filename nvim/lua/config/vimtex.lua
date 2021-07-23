---------- VIMTEX CONFIG ----------

local utils = require('seblj.utils')
local augroup = utils.augroup

vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_general_viewer = 'open -a Skim'
vim.g.vimtex_view_method = 'skim'

-- Clean latex files when quitting

augroup('VimtexConfig', {
    event = { 'User' },
    pattern = 'VimtexEventQuit',
    command = function()
        vim.fn['vimtex#compiler#clean'](0)
    end,
})
