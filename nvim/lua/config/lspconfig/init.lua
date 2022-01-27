---------- LSP CONFIG ----------

local M = {}
local utils = require('seblj.utils')
local augroup = utils.augroup
local settings = require('config.lspconfig.settings')
local nls_has_formatter = require('config.null-ls').has_formatter

require('config.lspconfig.install')

local autoformat = true

local toggle_format = function()
    autoformat = not autoformat
    if autoformat then
        vim.api.nvim_echo({ { 'Enabled autoformat on save' } }, false, {})
    else
        vim.api.nvim_echo({ { 'Disabled autoformat on save' } }, false, {})
    end
end

---------- MAPPINGS ----------

local mappings = function()
    local popupopts = {
        float = {
            border = 'rounded',
        },
    }
    local diagnostic_next = function()
        vim.diagnostic.goto_next(popupopts)
    end
    local diagnostic_prev = function()
        vim.diagnostic.goto_prev(popupopts)
    end
    local diagnostic_line = function()
        vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' })
    end
    local keymap = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = true
        vim.keymap.set(mode, l, r, opts)
    end

    keymap('n', '<leader>tf', toggle_format, { desc = 'Lsp: Toggle format' })
    keymap('n', 'gr', vim.lsp.buf.references, { desc = 'Lsp: References' })
    keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Lsp: Definitions' })
    keymap({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help, { desc = 'Lsp: Signature help' })
    keymap('n', 'gh', vim.lsp.buf.hover, { desc = 'Lsp: Hover' })
    keymap('n', 'gR', vim.lsp.buf.rename, { desc = 'Lsp: Rename' })
    keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Lsp: Code action' })
    keymap('n', 'gp', diagnostic_prev, { desc = 'Lsp: Previous diagnostic' })
    keymap('n', 'gn', diagnostic_next, { desc = 'Lsp: Next diagnostic' })
    keymap('n', '<leader>cd', diagnostic_line, { desc = 'Lsp: Line diagnostic' })

    augroup('AutoFormat', {
        event = 'BufWritePre',
        pattern = { '*.tsx', '*.ts', '*.js', '*.vue', '*.lua', '*.go', '*.rs', '*.json' },
        command = function()
            if autoformat then
                vim.lsp.buf.formatting_sync()
            end
        end,
    })
end

---------- SIGNS ----------

local signs = function()
    local sign_define = vim.fn.sign_define
    sign_define('DiagnosticSignError', { text = '✘', texthl = 'DiagnosticSignError' })
    sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
    sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
    -- sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
end

local disable_formatters = {
    'vuels',
    'tsserver',
}

M.make_config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    return {
        capabilities = capabilities,
        on_attach = function(client)
            require('config.lspconfig.handlers').handlers()
            mappings()
            signs()
            if client.server_capabilities.signatureHelpProvider then
                require('config.lspconfig.signature').setup(client)
            end
            if client.supports_method('textDocument/codeAction') then
                require('config.lspconfig.lightbulb').setup()
            end
            local ft = vim.api.nvim_buf_get_option(0, 'ft')
            if vim.tbl_contains(disable_formatters, client.name) or nls_has_formatter(ft) then
                client.resolved_capabilities.document_formatting = false
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
    'vuels',
    'jsonls',
    'graphql',
    'tsserver',
    'sumneko_lua',
    'clangd',
    'gopls',
    'omnisharp',
    'dockerls',
    'eslint',
    'ltex',
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
