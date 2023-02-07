---------- FORMATTER ----------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function prettierd()
    return {
        exe = "prettierd",
        args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    }
end

require("formatter").setup({
    filetype = {
        lua = function()
            return {
                exe = "stylua",
                args = { "--search-parent-directories", "--stdin-filepath", vim.api.nvim_buf_get_name(0), "-" },
            }
        end,
        go = function()
            return {
                exe = "goimports",
            }
        end,
        sql = function()
            return {
                exe = "sql-formatter",
                args = { "-l", "postgresql" },
            }
        end,
        rust = function()
            return {
                exe = "rustfmt",
                args = { "--edition", "2021" },
            }
        end,
        tex = function()
            return {
                exe = "latexindent",
            }
        end,
        json = function()
            return {
                exe = "jq",
            }
        end,
        javascript = prettierd,
        typescript = prettierd,
        javascriptreact = prettierd,
        typescriptreact = prettierd,
        vue = prettierd,
        css = prettierd,
        scss = prettierd,
        html = prettierd,
        yaml = prettierd,
        markdown = prettierd,
        graphql = prettierd,
    },
})

local group = augroup("Formatter", {})
autocmd("BufWritePost", {
    pattern = {
        "*.lua",
        "*.go",
        "*.js",
        "*.ts",
        "*.jsx",
        "*.tsx",
        "*.vue",
        "*.md",
        "*.css",
        "*.scss",
        "*.rs",
        "*.sql",
        "*.tex",
        "*.json",
    },
    group = group,
    callback = function()
        if not vim.b.disable_formatting then
            vim.cmd.FormatWrite()
        end
    end,
    desc = "Formatting",
})
