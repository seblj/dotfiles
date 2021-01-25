" Fix for not overwriting indentation settings
" Must be initialized before plugin
let g:polyglot_disabled = ['autoindent']

call plug#begin('~/.config/nvim/plugged')

    "Syntax and colorscheme
    Plug 'rafi/awesome-vim-colorschemes'
    " Plug 'ap/vim-css-color' 
    " Plug 'justinmk/vim-syntax-extra'	   
    " Plug 'sheerun/vim-polyglot'

    Plug 'tpope/vim-repeat'

    Plug 'puremourning/vimspector'
    Plug 'szw/vim-maximizer'

    "Statusline
    Plug 'itchyny/lightline.vim'

    " Language server
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Plug 'neovim/nvim-lspconfig'
    " Plug 'nvim-lua/completion-nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'
    
    " Git
    Plug 'itchyny/vim-gitbranch'
    Plug 'airblade/vim-gitgutter'

    " Tags and highlight with tags
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'vim-scripts/TagHighlight'

    " Filetree
    Plug 'scrooloose/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'

    " Search
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    
    " Plug 'nvim-lua/popup.nvim'
    " Plug 'nvim-lua/plenary.nvim'
    " Plug 'nvim-telescope/telescope.nvim'

    Plug 'mileszs/ack.vim'

    Plug 'lambdalisue/suda.vim'             " Write with sudo
    Plug 'Raimondi/delimitMate'             " Auto pairs of surrounds
    Plug 'tpope/vim-commentary'             " Easy comment
    Plug 'terryma/vim-multiple-cursors'     " Multiple cursor from sublime
    Plug 'tpope/vim-surround'               " Surround modification

    " Latex
    Plug 'lervag/vimtex'

    " Markdown
    " Plug 'JamshedVesuna/vim-markdown-preview'

call plug#end()

syntax on
" colorscheme afterglow-custom
colorscheme sonokai

highlight! link TSCustomType Purple
highlight! link TSProperty None
highlight! link TSParameter None

set regexpengine=1
set splitbelow
set splitright
set cmdheight=2
set clipboard=unnamedplus
set mouse=a
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set noswapfile
set number relativenumber
set completeopt=menuone,noinsert,noselect
set encoding=UTF-8
set foldmethod=indent
set foldlevelstart=20
set ignorecase
set smartcase
set cino+=L0

"" Allow larger undo history
set undofile                       " use an undo file
set undodir=$HOME/.vim/undo        " undo file path
set undolevels=1000
set undoreload=10000

autocmd BufRead,BufNewFile .gitignore_global set filetype=gitignore
autocmd BufRead,BufNewFile *.h,*.c set filetype=c
autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile * if &filetype ==# '' | setlocal spell | endif

" Load lua-file
lua require('init')

" let vim_markdown_preview_hotkey='<C-m>'
" let vim_markdown_preview_github=1
" let vim_markdown_preview_toggle=2

let g:vimsyn_embed= 'l'

" Hide tagfile by renaming from tags to .tags
let g:gutentags_ctags_tagfile = '.tags'

" Indent after enter with autopairs
let g:delimitMate_expand_cr = 1

" Python settings
" let g:python_highlight_all = 1 
" let g:python_highlight_space_errors = 0

let g:lightline = {
  \   'colorscheme': 'custom',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ], [ 'spell', 'gitbranch', 'readonly', 'filename', 'modified' ]],
  \     'right':[ ['lineinfo'], ['filetype']]
  \   },
  \   'component':{
  \     'lineinfo': "%{line('.') . '/' . line('$')}",
  \   },
  \   'component_function': {
  \     'gitbranch': 'gitbranch#name',
  \   }
  \ }
let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': '' 
  \}

" Nerdtree settings
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeChDirMode = 2
packloadall
silent! helptags ALL

"Latex
" let g:tex_flavor = 'latex'
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_general_viewer = 'open -a Skim'
let g:vimtex_view_method = 'skim'

" Clean latex files when quitting file
augroup vimtex_config
    au!
    au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END

" Set leaderkeys
let mapleader = " "
let maplocalleader = '\'

" Mappings

" Show full diagnostic message
nmap <silent><leader>cd <Plug>(coc-diagnostic-info)

" Add syntax for Type with tags
nmap <silent><leader>us :UpdateTypesFileOnly<CR>

" Paste in visual mode without yanking the text to overwrite
vmap <leader>p "_dP

" Toggle focus on one split
nnoremap <silent><leader>m :MaximizerToggle!<CR>

" Resize splits
nmap <leader>= <C-w>=

" Indent file
nmap <leader>i gg=G

" Easy replace word
nmap <leader>s :%s//gI<Left><Left><Left>
vmap <leader>s :s//gI<Left><Left><Left>

" Folding
nmap <leader>f za

" Unhighlight word
nmap <silent><leader>l :nohl<CR>

" Open fzf with Ctrl+p
map <silent><C-p> :update <bar> :Files<CR>

" Open new tab
nmap <silent><leader>t :tabedit <bar> :Files<CR>

"Debugger remaps
nmap <silent><leader>dd :call vimspector#Launch()<CR>
nmap <silent><leader>de :call vimspector#Reset()<CR>

" Enable dot repeat for some commands
nmap <silent><Plug>VimspectorStepOutRepeat :call vimspector#StepOut()<CR>
    \ :call repeat#set("\<Plug>VimspectorStepOutRepeat", v:count)<CR>

nmap <silent><Plug>VimspectorStepOverRepeat :call vimspector#StepOver()<CR>
    \ :call repeat#set("\<Plug>VimspectorStepOverRepeat", v:count)<CR>

nmap <silent><Plug>VimspectorStepIntoRepeat :call vimspector#StepInto()<CR>
    \ :call repeat#set("\<Plug>VimspectorStepIntoRepeat", v:count)<CR>

nmap <silent><Plug>VimspectorContinueRepeat :call vimspector#Continue()<CR>
    \ :call repeat$set("\<Plug>VimspectorContinueRepeat", v:count)<CR>

nmap <silent><Plug>VimspectorRunToCursorRepeat :call vimspector#RunToCursor()<CR>
    \ :call repeat#set("\<Plug>VimspectorRunToCursorRepeat", v:count)<CR>

nmap <silent><Plug>VimspectorToggleBreakpointRepeat :call vimspector#ToggleBreakpoint()<CR>
    \ :call repeat#set("\<Plug>VimspectorToggleBreakpointRepeat", v:count)<CR>

" Remap the comands created for repeat
nmap <Leader>dk <Plug>VimspectorStepOutRepeat
nmap <Leader>dj <Plug>VimspectorStepOverRepeat
nmap <Leader>dl <Plug>VimspectorStepIntoRepeat
nmap <leader>d_ <Plug>VimspectorRestart
nmap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursorRepeat
nmap <leader>db <Plug>VimspectorToggleBreakpointRepeat
nmap <leader>dcb <Plug>VimspectorToggleConditionalBreakpoint
nmap <leader>dw :VimspectorWatch 

" Ack (leader A search for word under cursor)
nmap <leader>a mA <bar> :Ack 
nmap <leader>A mA <bar> :Ack<CR>

" Function for using arrow keys as cnext and cprev in quickfix window
function! QuickFixFunc(key)
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        if a:key == "down"
            normal j
        else
            normal k
        endif
    else
        if a:key == "down"
            :silent! cnext
        else
            :silent! cprev
        endif
    endif
endfunction
nnoremap <silent> <Down> :call QuickFixFunc("down")<cr>
nnoremap <silent> <Up> :call QuickFixFunc("up")<cr>

" Leader and esc to close quickfix window and go back
" to mark set with leader a
nnoremap <silent> <leader><ESC> :cclose<CR> `A

" Tab or shift-tab to go to next or previous tab
nmap <silent><TAB> gt
nmap <silent><S-TAB> gT

" Keep visual when indenting
vmap < <gv
vmap > >gv

" Go to function using tags
nmap gd <C-]>
vmap gd <C-]>

" Go back from function using tags
nmap gb <C-t>
vmap gb <C-t>

" Coc.nvim settings
nmap <silent> gr <Plug>(coc-references)
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Remap VIM 0 to first non-blank character
map 0 ^

"Ctrl + hjkl to move to different windows
nmap <C-l> <C-w>l
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k

" Shift + arrow keys to resize split
nmap <silent><S-Right> :vertical resize -1<CR>
nmap <silent><S-Left> :vertical resize +1<CR>
nmap <silent><S-Up> :res +1<CR>
nmap <silent><S-Down> :res -1<CR>

"Alt + j = move line down
nmap <silent>√ :m.+1<CR>==
vmap <silent>√ :m '>+1<CR>gv=gv
imap <silent>√ <Esc>:m .+1<CR>==gi

"Alt + k = move line up
nmap <silent>ª :m.-2<CR>==
vmap <silent>ª :m '<-2<CR>gv=gv
imap <silent>ª <Esc>:m .-2<CR>==gi

" Nerdtree setting
nmap <silent>tnt :NERDTreeToggle<CR>
nmap <silent>rnt :NERDTreeRefreshRoot<CR>

" Shift + j/k to jump number of lines up/down
nmap J 10j
nmap K 10k
nmap H ^
nmap L $

vmap J 10j
vmap K 10k
vmap H ^
vmap L $

" Map in operatormode to make dL work like d$
onoremap L $
onoremap H ^

" Write file with sudo
cnoreabbrev w!! w suda://%

" Quit nvim with capital letters
command! -bang Q q<bang>
command! -bang W w<bang>

command! -bang WQ wq<bang>
command! -bang Wq wq<bang>

command! -bang Wqa wqa<bang>
command! -bang WQa wqa<bang>
command! -bang WQA wqa<bang>

command! -bang Wa wa<bang>
command! -bang WA wa<bang>

command! -bang Qa qa<bang>
command! -bang QA qa<bang>

" Use macros in visual mode
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

