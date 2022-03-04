---------- LSP CONFIG ----------

local M = {}
local settings = require('config.lspconfig.settings')

require('config.lspconfig.install')

---------- MAPPINGS ----------

local mappings = function()
    local keymap = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = true
        vim.keymap.set(mode, l, r, opts)
    end

    keymap('n', 'gr', vim.lsp.buf.references, { desc = 'Lsp: References' })
    keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Lsp: Definitions' })
    keymap({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help, { desc = 'Lsp: Signature help' })
    keymap('n', 'gh', vim.lsp.buf.hover, { desc = 'Lsp: Hover' })
    keymap('n', 'gR', vim.lsp.buf.rename, { desc = 'Lsp: Rename' })
    keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Lsp: Code action' })
    keymap('n', 'gp', vim.diagnostic.goto_prev, { desc = 'Lsp: Previous diagnostic' })
    keymap('n', 'gn', vim.diagnostic.goto_next, { desc = 'Lsp: Next diagnostic' })
    keymap('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Lsp: Line diagnostic' })
    keymap('n', '<leader>dw', vim.diagnostic.setqflist, { desc = 'Lsp: Diagnostics in qflist' })
end

---------- SIGNS ----------

local signs = function()
    local sign_define = vim.fn.sign_define
    sign_define('DiagnosticSignError', { text = '✘', texthl = 'DiagnosticSignError' })
    sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
    sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
    -- sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
end

M.make_config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    return {
        capabilities = capabilities,
        on_attach = function(client)
            require('config.lspconfig.handlers').handlers()
            require('config.lspconfig.formatting').setup(client)
            mappings()
            signs()
            if client.server_capabilities.signatureHelpProvider then
                require('config.lspconfig.signature').setup(client)
            end
            if client.supports_method('textDocument/codeAction') then
                require('config.lspconfig.lightbulb').setup()
            end
        end,
    }
end

local servers = {
    'pyright',
    'rust_analyzer',
    'cssls',
    'vimls',
    'texlab',
    'html',
    'bashls',
    -- 'vuels',
    'volar',
    'jsonls',
    'graphql',
    'tsserver',
    'sumneko_lua',
    'clangd',
    'gopls',
    'omnisharp',
    'dockerls',
    'eslint',
    -- 'ltex',
    -- 'grammarly',
}

-- Automatic setup for language servers
local setup_servers = function()
    for _, server in pairs(servers) do
        local config = M.make_config()

        -- Set user settings for each server
        if settings[server] then
            for k, v in pairs(settings[server]) do
                config[k] = v
            end
        end
        require('lspconfig')[server].setup(config)
    end
end

setup_servers()

return M
