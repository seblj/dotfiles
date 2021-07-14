local autocmd = require('seblj.utils').autocmd

autocmd({
    event = {'BufRead', 'BufNewFile'},
    pattern = {'*.graphql', '*.gql'},
    command = function()
        vim.opt.ft = 'graphql'
    end
})
