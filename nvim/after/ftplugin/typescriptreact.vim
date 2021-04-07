" Settings for typescriptreact

" 2 spaces for typescriptreact
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
inoremap <C-c> <Esc>T<"iyiw$a</<ESC>"ipa><ESC>F<i

" Quickfix for utoindent on enter between tags. 
" Only enable with completion-nvim. Coc handles this with coc#on#enter
if exists(':CompletionToggle')
    inoremap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ? "<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" : CheckChar() ? "\<CR>\<ESC>O" : "\<C-R>=delimitMate#ExpandReturn()\<CR>"
endif
func CheckChar()
    let left = matchstr(getline('.')[col('.') - 2 :], '^.')
    let right = matchstr(getline('.')[col('.') - 1 :], '^.')
    if left == '>' && right == '<'
        return 1
    else
        return 0
    endif
endfunc


highlight! link TSProperty Green


let b:jsx_pretty_old_cms = &l:commentstring

augroup jsx_comment
  autocmd! CursorMoved <buffer>
  autocmd CursorMoved <buffer> call comment#update_commentstring(b:jsx_pretty_old_cms)
augroup end

