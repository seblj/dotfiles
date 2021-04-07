---------- TREE-SITTER CONFIG ----------

require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
    }
}

require("nvim-treesitter.highlight")
local hlmap = vim.treesitter.highlighter.hl_map
hlmap["custom-type"]= "TSCustomType"
