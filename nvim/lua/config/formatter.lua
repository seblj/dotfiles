return {
    "seblj/nvim-formatter",
    dev = true,
    opts = {
        format_on_save = function()
            return not vim.b.disable_formatting
        end,
        treesitter = {
            auto_indent = {
                graphql = function()
                    return vim.bo.ft ~= "markdown"
                end,
            },
        },
        filetype = {
            lua = "stylua --search-parent-directories -",
            go = "goimports",
            sql = "sql-formatter -l postgresql",
            rust = {
                "rustfmt +nightly --edition 2021",
                "leptosfmt --stdin",
            },
            json = "jq",
            cs = "dotnet-csharpier",
            c = "clang-format",
            tex = "latexindent -g /dev/null",
            bib = "latexindent -g /dev/null",
            javascript = "prettierd .js",
            typescript = "prettierd .ts",
            javascriptreact = "prettierd .jsx",
            typescriptreact = "prettierd .tsx",
            vue = "prettierd .vue",
            css = "prettierd .css",
            scss = "prettierd .scss",
            html = "prettierd .html",
            yaml = "prettierd .yml",
            markdown = "prettierd .md",
            graphql = "prettierd .gql",
            zsh = "beautysh -",
            sh = "beautysh -",
        },
    },
}
