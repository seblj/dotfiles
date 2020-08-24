call plug#begin()
Plug 'rafi/awesome-vim-colorschemes'
Plug 'justinmk/vim-syntax-extra'	   
Plug 'w0rp/ale'
" Plug 'Shougo/echodoc.vim'
" Plug 'zchee/deoplete-clang'
Plug 'ap/vim-css-color'
Plug 'sheerun/vim-polyglot'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-commentary'
Plug 'rhysd/accelerated-jk'
Plug 'terryma/vim-multiple-cursors'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'mileszs/ack.vim'
Plug 'vim-scripts/taglist.vim'	
Plug 'ludovicchabant/vim-gutentags'

Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
call plug#end()

syntax on
colorscheme afterglow-custom

set splitbelow
set splitright
set cmdheight=2
set clipboard=unnamedplus
set mouse=a
set shiftwidth=4
set tabstop=4
set noswapfile
set number relativenumber
set completeopt=menu,noinsert
set encoding=UTF-8
set foldmethod=indent
set foldlevelstart=20
set ignorecase
set smartcase

" Allow larger undo history
set undofile                       " use an undo file
set undodir=$HOME/.vim/undo        " undo file path
set undolevels=1000
set undoreload=10000
autocmd BufRead,BufNewFile *.h,*.c set filetype=c

" Make echodoc show arguments in float window

" " Or, you could use neovim's floating text feature.
" let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'floating'
" " To use a custom highlight for the float window,
" " change Pmenu to your highlight group
" highlight link EchoDocFloat Pmenu

" let g:deoplete#enable_at_startup = 1
" let g:echodoc_enable_at_startup = 1
" let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/9.0.1/lib/libclang.dylib'
" call deoplete#custom#source('clang', 'rank', 9999)

let g:delimitMate_expand_cr = 1

" Python settings
let g:python_highlight_all = 1 
let g:python_highlight_space_errors = 0

" Nerdtree settings
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" Semshi settings
" let g:semshi#excluded_hl_groups = ['global', 'local']
let g:semshi#mark_selected_nodes = 0
let g:semshi#error_sign = 0
let g:semshi#update_delay_factor = 0.01
let g:semshi#excluded_hl_groups = ['local', 'attribute', 'imported']

" Airline settings
let g:airline_section_warning = 0
let g:airlin#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#ale#enabled = 1
"Font for symbols"
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif


"Ale settings"
" always have a column, and only lint on save"

let g:ale_linters = {
\   'c': ['clang'],
\}
let g:ale_sign_column_always = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_c_parse_makefile = 1

" Tlist settings
let g:Tlist_Close_On_Select = 1
let g:Tlist_GainFocus_On_ToggleOpen = 1

"Nerdtree settings
let g:NERDTreeChDirMode = 2
packloadall
silent! helptags ALL

let mapleader = " "

" Mappings
vnoremap < <gv
vnoremap > >gv

nnoremap <C-i> gg=G

nnoremap gd <C-]>
vnoremap gd <C-]>

nnoremap gb <C-t>
vnoremap gb <C-t>

" Settings for Coc
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Complete the word and not the snippet and also enhanced <CR> experience
" auto pairs.
" inoremap <silent><expr> <CR> pumvisible() ? "\<C-n><C-p>": "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" imap <expr> <cr> pumvisible() ? "\<C-n><C-p>" : "\<C-g>u\<Plug>delimitMateCR"

" Alias replace all to S
nnoremap <leader>s :%s//gI<Left><Left><Left>

" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove 
" map <leader>t<leader> :tabnext 


" Remap VIM 0 to first non-blank character
map 0 ^

"Ctrl + hjkl to move to different windows
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"Alt + j = move line down
nnoremap √ :m.+1<CR>==
vnoremap √ :m '>+1<CR>gv=gv
inoremap √ <Esc>:m .+1<CR>==gi

"Alt + k = move line up
nnoremap ª :m.-2<CR>==
vnoremap ª :m '<-2<CR>gv=gv
inoremap ª <Esc>:m .-2<CR>==gi

"Wrap selected inside:
vnoremap ( d<ESC>i()<ESC>P
vnoremap [ d<ESC>i[]<ESC>P
vnoremap { d<ESC>i{}<ESC>P
vnoremap " d<ESC>i""<ESC>P
vnoremap ' d<ESC>i''<ESC>P

"Fold with space
nnoremap <leader>f za


nnoremap tl :TlistToggle<CR>
" nnoremap tlc :TlistClose<CR>

"nt to go to nt"
nnoremap nt 1<C-w>w
"tnt to toggle nerdtree"
nnoremap tnt :NERDTreeToggle<CR>
"rnt to refresh nerdtree root"
nnoremap rnt :NERDTreeRefreshRoot<CR>

"shift + j/k = jump 25 lines up/down
nnoremap <S-J> 25j
nnoremap <S-K> 25k

" Open new tab
nnoremap <C-t> :tabedit<CR>

"ctr + l = unhighlight words
nnoremap <silent> ﬁ :nohl<CR><C-l>

nnoremap zz :update<cr>

" Accelerate j and k
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)


"quit nvim with capital letters.
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang WQ wq<bang>
command! -bang Wq wq<bang>

"open fzf with Ctrl+p
map <C-p> :update <bar> :Files<CR>

" augroup remember_folds
" 	autocmd!
" 	autocmd BufWinLeave * mkview
" 	autocmd BufWinEnter * silent! loadview
" augroup END

autocmd ColorScheme * call MyCustomHighlights()
