local augroup = require('seblj.utils').augroup
augroup('GraphQLDetect', {
    event = { 'BufRead', 'BufNewFile' },
    pattern = { '*.graphql', '*.gql' },
    command = function()
        vim.opt.ft = 'graphql'
    end,
})
