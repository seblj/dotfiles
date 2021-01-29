--LSP
require'completion'.addCompletionSource('vimtex', require'vimtex'.complete_item)

require'lspconfig'.clangd.setup {}
require'lspconfig'.pyls.setup{
    settings = { pyls = { plugins = {
        pycodestyle = { enabled = false },
        pylint = { enabled = false }
    } } } 
}
require'lspconfig'.vimls.setup{}
require'lspconfig'.texlab.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.denols.setup{
    init_options = {
      enable = true,
      lint = true,
      unstable = false
    }}
require'lspconfig'.sqlls.setup{
    cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"};
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    -- virtual_text = {
    --     prefix = '~',  
    -- },
    virtual_text = false,
    signs = true,
    update_in_insert = false,
}
)

vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignError", {text = "✘", texthl = "LspDiagnosticsSignError"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}})
