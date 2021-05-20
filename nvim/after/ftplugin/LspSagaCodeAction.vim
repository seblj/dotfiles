lua require('seblj.utils').setup_hidden_cursor()
lua require('seblj.utils').hide_cursor()

" hack to get cursorline to work with minimal style window api.
call feedkeys(":echo ''\<CR>", 'n')
