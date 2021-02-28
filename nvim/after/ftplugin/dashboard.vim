" Start new file and enter insert mode on i
nmap <buffer> <silent> i :DashboardNewFile<CR>a

" Cursorline in dashboard file
setlocal cursorline
autocmd BufLeave * if &ft ==# 'dashboard' | execute 'setlocal nocursorline'  | endif 
