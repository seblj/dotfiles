---------- TREESITTER CONFIG ----------

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        disable = { 'latex' },
    },
})

local hlmap = vim.treesitter.highlighter.hl_map
hlmap['custom-type'] = 'TSCustomType'

-- Override html query to remove the stupid lines before tags
local function get_ft_query(ft, type)
    local path = (vim.fn.stdpath('config') .. ('/queries/' .. ft .. '/' .. type .. '.scm'))
    return vim.fn.join(vim.fn.readfile(path), '\n')
end

local vim_ts_queries = require('vim.treesitter.query')
vim_ts_queries.set_query('html', 'highlights', get_ft_query('html', 'highlights'))
vim_ts_queries.set_query('vue', 'highlights', get_ft_query('vue', 'highlights'))

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
parser_configs.http = {
    install_info = {
        url = 'https://github.com/NTBBloodbath/tree-sitter-http',
        files = { 'src/parser.c' },
        branch = 'main',
    },
}

require('nvim-treesitter.configs').setup({
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',

                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',

                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>sa'] = '@parameter.inner',
                ['<leader>sf'] = '@function.outer',
            },
            swap_previous = {
                ['<leader>sA'] = '@parameter.inner',
                ['<leader>sF'] = '@function.outer',
            },
        },
    },

    -- Comments
    context_commentstring = {
        enable = true,
        disable = { 'c' },
    },

    autotag = {
        enable = true,
    },
})
