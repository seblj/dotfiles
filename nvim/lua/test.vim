call plug#begin('~/.config/nvim/plugged')
    Plug 'hoob3rt/lualine.nvim'
call plug#end()

lua require('my_lualine')
