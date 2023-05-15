---------- TREESITTER CONFIG ----------

vim.treesitter.language.register("bash", "zsh")

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
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
})
