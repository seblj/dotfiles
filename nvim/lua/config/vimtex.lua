---------- VIMTEX CONFIG ----------

local g, exec = vim.g, vim.api.nvim_exec

g.tex_flavor = 'latex'
g.vimtex_quickfix_mode = 0
g.vimtex_general_viewer = 'open -a Skim'
g.vimtex_view_method = 'skim'

-- Clean latex files when quitting
exec([[
augroup vimtex_config
    au!
    au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END
]], false)
