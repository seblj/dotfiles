---------- LSP CONFIG ----------

local M = {}
local utils = require('seblj.utils')
local nnoremap = vim.keymap.nnoremap
local inoremap = vim.keymap.inoremap
local vnoremap = vim.keymap.vnoremap
local augroup = utils.augroup
local lsp_settings = require('config.lspconfig.settings').settings

require('config.lspconfig.install')

local autoformat = true

M.toggle_format = function()
    autoformat = not autoformat
    if autoformat then
        vim.api.nvim_echo({ { 'Enabled autoformat on save' } }, false, {})
    else
        vim.api.nvim_echo({ { 'Disabled autoformat on save' } }, false, {})
    end
end

-- stylua: ignore
nnoremap({ '<leader>tf', function() require('config.lspconfig').toggle_format() end }) -- Toggle autoformat on save

---------- MAPPINGS ----------

local mappings = function()
    local popupopts = {
        popup_opts = {
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
    nnoremap({ '<leader>cd', function() vim.diagnostic.show_line_diagnostics() end })
    nnoremap({ 'gb', '<C-t>' })
    vnoremap({ 'gb', '<C-t>' })
    -- stylua: ignore end

    augroup('AutoFormat', {
        event = 'BufWritePre',
        pattern = { '*.tsx', '*.ts', '*.js', '*.vue', '*.lua', '*.go' },
        command = function()
            if autoformat then
                vim.lsp.buf.formatting_sync()
            end
        end,
    })
end

---------- SIGNS ----------

local signs = function()
    vim.api.nvim_call_function(
        'sign_define',
        { 'DiagnosticSignError', { text = '✘', texthl = 'DiagnosticSignError' } }
    )
    vim.api.nvim_call_function('sign_define', {
        'DiagnosticSignWarn',
        { text = '', texthl = 'DiagnosticSignWarn' },
    })
    vim.api.nvim_call_function('sign_define', { 'DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' } })
    -- vim.api.nvim_call_function("sign_define", {"DiagnosticSignInfo", {text = "", texthl = "DiagnosticSignInfo"}})

    require('lspkind').init()
end

-- Use null-ls formatting instead of builtin
local disabled_formatting = {
    'tsserver', -- eslint/prettier
    'vue', -- eslint/prettier
    'lua', -- stylua
    'gopls', -- goimports
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
            if vim.tbl_contains(disabled_formatting, client.name) then
                client.resolved_capabilities.document_formatting = false
            end
        end,
    }
end

-- Setup null-ls
if pcall(require, 'null-ls') then
    require('config.lspconfig.settings').nls_setup()
end

local servers = {
    'null-ls',
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
}

-- Automatic setup for language servers
local setup_servers = function()
    for _, server in pairs(servers) do
        local config = make_config()

        -- Set user settings for each server
        if lsp_settings[server] then
            for k, v in pairs(lsp_settings[server]) do
                config[k] = v
            end
        end
        require('lspconfig')[server].setup(config)
    end
    -- if not package.loaded['sg.lsp'] then
    --     require('sg.lsp').setup(make_config())
    -- end
end

setup_servers()

return M
