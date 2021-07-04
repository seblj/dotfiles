if vim.fn.executable('stylua') == 1 then
    vim.cmd([[
        augroup StyLua
            au!
            autocmd BufWritePre <buffer> silent! :lua require('seblj.stylua').format()
        augroup END
    ]])
end
