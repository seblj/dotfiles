"" Fix for not overwriting indentation settings
"" Must be initialized before plugin
let g:polyglot_disabled = ['autoindent']

call plug#begin()

"    "Syntax and colorscheme
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'justinmk/vim-syntax-extra'	   
    Plug 'ap/vim-css-color'
    Plug 'sheerun/vim-polyglot'

    "Statusline
    Plug 'vim-airline/vim-airline'

    " Language server
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neoclide/coc-python'
    " Plug 'dense-analysis/ale'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Tags and highlight with tags
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'vim-scripts/TagHighlight'
    Plug 'vim-scripts/taglist.vim'	

    " Filetree
    Plug 'scrooloose/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'

    " Search
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'mileszs/ack.vim'

    Plug 'lambdalisue/suda.vim'             " Write with sudo
    Plug 'Raimondi/delimitMate'             " Auto pairs of surrounds
    Plug 'tpope/vim-commentary'             " Easy comment
    Plug 'rhysd/accelerated-jk'             " Faster jk
    Plug 'terryma/vim-multiple-cursors'     " Multiple cursor from sublime
    Plug 'tpope/vim-surround'               " Surround modification

    " Latex
    Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
    Plug 'lervag/vimtex'

call plug#end()

syntax on
colorscheme afterglow-custom

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
set completeopt=menu,noinsert
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

autocmd BufRead,BufNewFile *.h,*.c set filetype=c
autocmd BufRead,BufNewFile *.tex setlocal spell

" Indent after enter with autopairs
let g:delimitMate_expand_cr = 1

" Python settings
let g:python_highlight_all = 1 
let g:python_highlight_space_errors = 0

" Airline settings
let g:airline_section_warning = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#ale#enabled = 1

" Tabline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_tab_type = 0

"Font for symbols"
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
    let g:airline_symbols.dirty=''
    let g:airline_symbols.notexists = ''
endif

"Ale settings"
" always have a column, and only lint on save"

" let g:ale_linters = {
" 			\   'c': ['clang'],
" 			\}

" let g:ale_lint_on_insert_leave = 0
" let g:ale_sign_column_always = 0
" let g:ale_sign_highlight_linenrs = 1
" let g:ale_lint_on_text_changed = 0
" let g:ale_lint_on_enter = 0
" let g:ale_lint_on_save = 1
" let g:ale_c_parse_makefile = 1
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = ''
" let g:ale_sign_info = ''
" " Set color for line number and error sign to red, and warning sign to orange
" highlight ALEErrorSignLineNr ctermbg=NONE ctermfg=red
" highlight ALEErrorSign ctermbg=NONE ctermfg=red
" highlight ALEWarningSign ctermbg=NONE ctermfg=130

" Nerdtree settings
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeChDirMode = 2
packloadall
silent! helptags ALL

"Latex
let g:livepreview_cursorhold_recompile = 0 "recompile when saving"
let g:livepreview_previewer = 'open -a Skim'
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_general_viewer = 'open -a Skim'

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
nmap <silent><leader>d <Plug>(coc-diagnostic-info)

" Add syntax for Type with tags
nmap <silent><leader>us :UpdateTypesFileOnly<CR>

" Start preview for latex
" nmap <silent><leader>sp :LLPStartPreview<CR>

" Focus on single split without quiting the others
nmap <leader>o <C-w>_ <C-w>\|

nmap <leader>= <C-w>=

" Ack
nmap <leader>a :Ack 

" Indent file
nmap <leader>i gg=G

" Easy replace word
nmap <leader>s :%s//gI<Left><Left><Left>

" Folding
nmap <leader>f za

" Unhighlight word
nmap <silent><leader>l :nohl<CR>

" Open new tab
nmap <silent><leader>t :tabedit<CR>

" Tab or shift-tab to go to next or previous tab
nmap <silent><TAB> gt
nmap <silent><S-TAB> gT

" Open fzf with Ctrl+p
map <silent><C-p> :update <bar> :Files<CR>

" Keep visual when indenting
vmap < <gv
vmap > >gv

" Toggle taglist
nmap <silent>tl :TlistToggle<CR>1<C-w>w

" Go to function using tags
nmap gd <C-]>
vmap gd <C-]>

" Go back from function using tags
nmap gb <C-t>
vmap gb <C-t>

" Coc.nvim settings
nmap <silent> gr <Plug>(coc-references)
imap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

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
nmap J 25j
nmap K 25k

vmap J 25j
vmap K 25k

" Accelerate j and k
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

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


