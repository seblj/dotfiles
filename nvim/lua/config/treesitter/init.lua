---------- TREESITTER CONFIG ----------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local treesitter_parsers = require("nvim-treesitter.parsers")
local utils = require("seblj.utils")

local ft_to_parser = treesitter_parsers.filetype_to_parsername
ft_to_parser.zsh = "bash"

require("config.treesitter.commentstring")

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.rsx = {
    install_info = {
        url = "https://github.com/seblj/tree-sitter-rsx",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "comments",
    },
}

autocmd("FileType", {
    pattern = "rust",
    group = augroup("RustOverrideQuery", { clear = true }),
    callback = function()
        utils.override_queries("rust", "injections")
    end,
    desc = "Override rust treesitter injection",
})

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = utils.difference(treesitter_parsers.available_parsers(), {
            "tsx",
            "typescript",
            "vue",
            "javascript",
        }),
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
