---------- COC CONFIG ----------

local utils = require'utils'
local cmd, opt, map, exec = vim.cmd, utils.opt, utils.map, vim.api.nvim_exec

opt('o', 'completeopt', 'menuone,noinsert,noselect')

map('n', 'gd', ':call Goto_tag("Definition")<CR>', {noremap = false})
map('n', 'gb', '<C-t>')
map('n', 'gh', ':call Show_documentation()<CR>')
map('n', 'gR', '<Plug>(coc-rename)', {noremap = false})
map('n', '<leader>cd', '<Plug>(coc-diagnostic-info)', {noremap = false})
map('i', '<c-space>', 'coc#refresh()', {expr = true})
-- Autoformat closing tags with vim-closetag
map('i', '<CR>', 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>\\<C-r>=coc#on_enter()\\<CR>"', {expr = true})



exec(
[[
function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
]],
false
)

exec(
[[
function! Goto_tag(tagkind) abort
  let tagname = expand('<cWORD>')
  let winnr = winnr()
  let pos = getcurpos()
  let pos[0] = bufnr()

  if CocAction('jump' . a:tagkind)
    call settagstack(winnr, {'curidx': gettagstack()['curidx'], 'items': [{'tagname': tagname, 'from': pos}]}, 't')
  endif
endfunction
]],
false
)
