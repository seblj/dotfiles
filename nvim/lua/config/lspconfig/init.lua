---------- LSP CONFIG ----------

local M = {}
local utils = require('seblj.utils')
local nnoremap = vim.keymap.nnoremap
local inoremap = vim.keymap.inoremap
local augroup = utils.augroup
local settings = require('config.lspconfig.settings')
local nls = require('config.lspconfig.null-ls')

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

-- stylua: ignore
nnoremap({ '<leader>tf', function() toggle_format() end }) -- Toggle autoformat on save

---------- MAPPINGS ----------

local mappings = function()
    local popupopts = {
        float = {
            border = 'rounded',
        },
    }
    -- stylua: ignore start
    nnoremap({ 'gr', function() vim.lsp.buf.references() end })
    nnoremap({ 'gd', function() vim.lsp.buf.definition() end })
    inoremap({ '<C-s>', function() vim.lsp.buf.signature_help() end })
    nnoremap({ '<C-s>', function() vim.lsp.buf.signature_help() end })
    nnoremap({ 'gh', function() vim.lsp.buf.hover() end })
    nnoremap({ 'gR', function() vim.lsp.buf.rename() end })
    nnoremap({ '<leader>ca', function() vim.lsp.buf.code_action() end })
    nnoremap({ 'gp', function() vim.diagnostic.goto_prev(popupopts) end })
    nnoremap({ 'gn', function() vim.diagnostic.goto_next(popupopts) end })
    nnoremap({ '<leader>cd', function() vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' }) end })
    nnoremap({ 'gb', '<C-t>' })
    -- stylua: ignore end

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

-- stylua: ignore
local signs = function()
    vim.api.nvim_call_function('sign_define', { 'DiagnosticSignError', { text = '✘', texthl = 'DiagnosticSignError' } })
    vim.api.nvim_call_function('sign_define', { 'DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' } })
    vim.api.nvim_call_function('sign_define', { 'DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' } })
    -- vim.api.nvim_call_function('sign_define', { 'DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' } })
end

local disable_formatters = {
    'vuels',
    'tsserver',
}

local make_config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    return {
        capabilities = capabilities,
        on_attach = function(client)
            require('config.lspconfig.handlers').handlers()
            mappings()
            signs()
            require('config.lspconfig.signature').setup()
            require('config.lspconfig.lightbulb').setup()
            local ft = vim.api.nvim_buf_get_option(0, 'ft')
            local enabled = false
            if nls.nls_has_formatter(ft) then
                enabled = client.name == 'null-ls'
            else
                enabled = not (client.name == 'null-ls')
            end
            client.resolved_capabilities.document_formatting = enabled
            if vim.tbl_contains(disable_formatters, client.name) then
                client.resolved_capabilities.document_formatting = false
            end
        end,
    }
end

-- Setup null-ls
if pcall(require, 'null-ls') then
    nls.nls_setup()
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
    -- 'grammarly',
}

-- Automatic setup for language servers
local setup_servers = function()
    for _, server in pairs(servers) do
        local config = make_config()

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
