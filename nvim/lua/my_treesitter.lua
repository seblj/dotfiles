-- Tree-sitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
    }
}

require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.highlighter.hl_map
hlmap["custom-type"]= "TSCustomType"


