---------- VIMTEX CONFIG ----------

local cmd, fn, g, exec = vim.cmd, vim.fn, vim.g, vim.api.nvim_exec
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

g.tex_flavor = 'latex'
g.vimtex_quickfix_mode = 0
g.vimtex_general_viewer = 'open -a Skim'
g.vimtex_view_method = 'skim'

-- Clean latex files when quitting
exec(
[[
augroup vimtex_config
    au!
    au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END
]],
false
)
