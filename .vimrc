call plug#begin('~/.vim/plugged')
	Plug 'rafi/awesome-vim-colorschemes'
	Plug 'justinmk/vim-syntax-extra'	   
	Plug 'numirias/semshi'
	Plug 'octol/vim-cpp-enhanced-highlight'
	Plug 'w0rp/ale'
	Plug 'Shougo/echodoc.vim'
	Plug 'zchee/deoplete-clang'

	Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-airline/vim-airline'

	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'airblade/vim-gitgutter'
	
	Plug 'terryma/vim-multiple-cursors'
	Plug 'jiangmiao/auto-pairs'
	Plug 'tpope/vim-commentary'
	Plug 'rhysd/accelerated-jk'

	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'mileszs/ack.vim'

	Plug 'ludovicchabant/vim-gutentags'
	Plug 'vim-scripts/taglist.vim'	

	Plug 'scrooloose/nerdtree'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
call plug#end()

syntax on
colorscheme afterglow-custom
" colorscheme custom

" Make echodoc show arguments in float window

" " Or, you could use neovim's floating text feature.
" let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'floating'
" " To use a custom highlight for the float window,
" " change Pmenu to your highlight group
" highlight link EchoDocFloat Pmenu

let g:deoplete#enable_at_startup = 1
let g:echodoc_enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/9.0.1/lib/libclang.dylib'
call deoplete#custom#source('clang', 'rank', 9999)


let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1


set cmdheight=2
set clipboard=unnamedplus
set mouse=a
set shiftwidth=4
set tabstop=4
set noswapfile
set number relativenumber
set completeopt=menu,noinsert
set encoding=UTF-8

" Allow larger undo history
set undofile                       " use an undo file
set undodir=$HOME/.vim/undo        " undo file path
set undolevels=1000
set undoreload=10000


" let g:semshi#excluded_hl_groups = ['global', 'local']
let g:semshi#mark_selected_nodes = 0
let g:semshi#error_sign = 0
let g:semshi#update_delay_factor = 0.01
let g:semshi#excluded_hl_groups = ['local', 'attribute', 'imported']

"air-line"
let g:airline_section_warning = 0
let g:airlin#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#ale#enabled = 1
"Font for symbols"
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif


"Ale"
" always have a column, and only lint on save"

 " let g:ale_linters = {
 " \   'c': ['clang'],
 " \}
let g:ale_sign_column_always = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_c_parse_makefile = 1

let g:Tlist_Close_On_Select = 1
let g:Tlist_GainFocus_On_ToggleOpen = 1


"Nerdtree"
let g:NERDTreeChDirMode = 2
packloadall
silent! helptags ALL

vnoremap < <gv
vnoremap > >gv

nnoremap <C-i> gg=G
nnoremap <A-i> gg=G


nnoremap gd <C-]>
vnoremap gd <C-]>

nnoremap gb <C-t>
vnoremap gb <C-t>

"alt+l to the right-window"
nnoremap <C-l> <C-w>l
"alt+h arrown to move to the left-window"
nnoremap <C-h> <C-w>h
"Alt + j = move line down
nnoremap <C-j> :m.+1<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
inoremap <C-j> <Esc>:m .+1<CR>==gi

"Alt + k = move line up
nnoremap <C-k> :m.-2<CR>==
vnoremap <C-k> :m '<-2<CR>gv=gv
inoremap <C-k> <Esc>:m .-2<CR>==gi

"Wrap selected inside:
vnoremap ( d<ESC>i()<ESC>P
vnoremap [ d<ESC>i[]<ESC>P
vnoremap { d<ESC>i{}<ESC>P
vnoremap " d<ESC>i""<ESC>P
vnoremap ' d<ESC>i''<ESC>P


nnoremap <leader>i gg=G

nnoremap tl :TlistToggle<CR>
" nnoremap tlc :TlistClose<CR>

"nt to go to nt"
nnoremap nt 1<C-w>w
"tnt to toggle nerdtree"
nnoremap tnt :NERDTreeToggle<CR>
"rnt to refresh nerdtree root"
nnoremap rnt :NERDTreeRefreshRoot<CR>

"shift + j = jump 10 lines down
nnoremap <S-J> :+10<CR>

"shift + k = jump 10 lines up
nnoremap <S-K> :-10<CR>

nnoremap <C-t> :tabedit<CR>

"tab = go to next tab
nnoremap <tab> :tabn<CR>
"shift + tab = go to previous tab
nnoremap <S-tab> :tabp<CR>

"ctr + l = unhighlight words
nnoremap <silent> ﬁ :nohl<CR><C-l>

nnoremap zz :update<cr>

nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

"quit nvim with capital letters. '!' not working
:command Q q
:command W w
:command WQ wq
:command Wq wq

"open fzf with ;
map ; :update <bar> :Files<CR>

autocmd ColorScheme * call MyCustomHighlights()
