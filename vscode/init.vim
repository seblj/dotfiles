set number
set relativenumber
set hlsearch
set incsearch
set ignorecase
set smartcase
set clipboard=unnamedplus

let mapleader = " "

nmap j gj
nmap k gk
vmap j gj
vmap k gk

nmap J 10gj
nmap K 10gk
vmap J 10gj
vmap K 10gk

nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
onoremap H ^
onoremap L $

nnoremap <leader>x :source ~/dotfiles/vscode/init.vim<CR>

vnoremap < <gv
vnoremap > >gv

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="IncSearch", timeout=150 })
augroup END
