---------- OPTIONS ----------

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local cmd, g = vim.cmd, vim.g

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

cmd 'colorscheme sonokai'
cmd 'syntax on'
cmd 'filetype plugin indent on'

opt('o', 'splitbelow', true)
opt('o', 'splitright', true)
-- opt('o', 'updatetime', 250)
opt('o', 'cmdheight', 2)
opt('o', 'clipboard', 'unnamedplus')
opt('o', 'mouse', 'a')
opt('b', 'tabstop', 4)
opt('b', 'expandtab', true)
opt('b', 'softtabstop', 4)
opt('b', 'shiftwidth', 4)
opt('b', 'swapfile', false)
opt('w', 'number', true)
opt('w', 'relativenumber', true)
opt('w', 'foldmethod', 'indent')
opt('o', 'foldlevelstart', 20)
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)
opt('o', 'termguicolors', true)
opt('b', 'cino', 'L0')
opt('b', 'undofile', true)
opt('o', 'undolevels', 1000)
opt('o', 'undoreload', 10000)

cmd("autocmd BufRead,BufNewFile .gitignore_global set filetype=gitignore")
cmd("autocmd BufWritePre * %s/\\s\\+$//e")
cmd("autocmd BufRead,BufNewFile *.tex setlocal spell")
cmd("autocmd BufRead,BufNewFile * if &filetype ==# '' | setlocal spell | endif")
cmd("autocmd BufRead,BufNewFile *.h,*.c set filetype=c")
cmd([[autocmd BufRead,BufNewFile *.tsx setlocal commentstring={/*\ %s\ */}]])

g.vimsyn_embed = 'l'
g.delimitMate_expand_cr = 1
g.closetag_filenames = '*.html,*.tsx'
g.closetag_regions = {typescriptreact = 'jsxRegion,tsxRegion'}
