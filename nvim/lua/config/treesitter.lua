---------- TREE-SITTER CONFIG ----------

local cmd = vim.cmd

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
    }
}

require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.highlighter.hl_map
hlmap["custom-type"]= "TSCustomType"

-- Set filetype which sets syntax because tree-sitter breaks set syntax
cmd("autocmd BufRead,BufNewFile * execute(':set ft:'.&ft)")

