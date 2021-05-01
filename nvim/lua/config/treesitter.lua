---------- TREE-SITTER CONFIG ----------

require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
    },
}

require("nvim-treesitter.highlight")
local hlmap = vim.treesitter.highlighter.hl_map
hlmap["custom-type"]= "TSCustomType"

require'nvim-treesitter.configs'.setup {
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
}
