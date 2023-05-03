---------- FORMATTER ----------

require("formatter").setup({
    format_on_save = function()
        return not vim.b.disable_formatting
    end,
    filetype = {
        lua = { "stylua", "--search-parent-directories", "-" },
        go = "goimports",
        sql = { "sql-formatter", "-l", "postgresql" },
        rust = { "rustfmt", "--edition", "2021" },
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
        zsh = "shfmt -i 4",
        sh = "shfmt -i 4",
    },
})

---------- LSP FORMATTING ----------

local format_clients = {
    "eslint",
}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if vim.tbl_contains(format_clients, client.name) then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
                buffer = args.buf,
                callback = function()
                    if not vim.b.disable_formatting then
                        if client.name == "eslint" then
                            vim.cmd.EslintFixAll()
                        else
                            vim.lsp.buf.format()
                        end
                    end
                end,
                desc = "Formatting lsp",
            })
        end
    end,
})
