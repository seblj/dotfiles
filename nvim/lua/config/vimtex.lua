---------- VIMTEX CONFIG ----------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_general_viewer = 'open -a Skim'
vim.g.vimtex_view_method = 'skim'

-- Clean latex files when quitting

local group = augroup('VimtexConfig', {})
autocmd('User', {
    group = group,
    pattern = 'VimtexEventQuit',
    callback = function()
        vim.fn['vimtex#compiler#clean'](0)
    end,
})
