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

local function format_sql_inline()
    local rust_sql = vim.treesitter.parse_query(
        "rust",
        [[
        (macro_invocation
            (scoped_identifier
                path: (identifier) @path (#eq? @path "sqlx")
                name: (identifier) @name (#match? @name "query")
            )
            (token_tree
                (raw_string_literal) @target
            )
        )
        (call_expression
            (field_expression
                field: (field_identifier) @_field (#any-of? @_field "query" "execute")
            )
            (arguments
                (raw_string_literal) @target
            )
        )
        (macro_invocation
            macro: (identifier) @_macro (#any-of? @_macro "fetch_optional" "fetch_all" "insert" "execute")
            (token_tree
                (raw_string_literal) @target
            )
        )
    ]]
    )

    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(vim.api.nvim_get_current_buf(), "rust", {})
    local tree = parser:parse()[1]
    local root = tree:root()

    for id, node in rust_sql:iter_captures(root, bufnr, 0, -1) do
        local name = rust_sql.captures[id]
        if name == "target" then
            -- { start_row, start_col, end_row, end_col}
            local range = { node:range() }
            local text = vim.treesitter.get_node_text(node, bufnr)
            text = string.sub(text, 4, #text - 3)

            require("formatter").format(range[1] + 2, range[3], {
                exe = "sql-formatter",
                args = { "-l", "postgresql" },
            })
        end
    end
end

local group = augroup("Formatter", {})
autocmd("BufWritePre", {
    pattern = { "*.lua", "*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.md", "*.css", "*.scss", "*.rs" },
    group = group,
    callback = function()
        if vim.b.do_formatting ~= false then
            if vim.bo.ft == "rust" then
                format_sql_inline()
            else
                vim.cmd.Format()
            end
        end
    end,
    desc = "Formatting",
})
