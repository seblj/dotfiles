if vim.fn.executable('stylua') == 1  and vim.fn.exists('LspInfo') == 1 then
    vim.cmd([[
        augroup StyLua
            au!
            autocmd BufWritePre <buffer> :lua require('seblj.stylua').format()
        augroup END
    ]])
end
