---------- TREESITTER CONFIG ----------

local treesitter_parsers = require("nvim-treesitter.parsers")
local ft_to_parser = treesitter_parsers.filetype_to_parsername
ft_to_parser.zsh = "bash"

require("config.treesitter.commentstring")

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = vim.tbl_filter(function(val)
            return not vim.tbl_contains({ "tsx", "typescript", "vue", "javascript" }, val)
        end, treesitter_parsers.available_parsers()),
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",

                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>sa"] = "@parameter.inner",
                ["<leader>sf"] = "@function.outer",
            },
            swap_previous = {
                ["<leader>sA"] = "@parameter.inner",
                ["<leader>sF"] = "@function.outer",
            },
        },
    },

    autotag = {
        enable = true,
    },
})
