-- Tree-sitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
    }
}

-- Telescope
require('telescope').setup{}


-- LSP
-- require'lspconfig'.clangd.setup {on_attach=require'completion'.on_attach}
-- require'lspconfig'.pyls.setup{
--     on_attach=require'completion'.on_attach,
--     settings = { pyls = { plugins = {
--         pycodestyle = { enabled = false },
--         pylint = { enabled = false }
--     } } } 
-- }
-- require'lspconfig'.vimls.setup{on_attach=require'completion'.on_attach}
-- require'lspconfig'.texlab.setup{on_attach=require'completion'.on_attach}
-- require'lspconfig'.sqlls.setup{
--     on_attach=require'completion'.on_attach
-- }
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
-- vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = false,
--     signs = true,
--     update_in_insert = false,
-- }
-- )
