---------- LSP CONFIG ----------

local M = {}
local utils = require('seblj.utils')
local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap
local inoremap = map.inoremap
local vnoremap = map.vnoremap
local autocmd = utils.autocmd
local lsp_settings = require('config.lspconfig.settings').settings

local autoformat = true

M.toggle_format = function()
    autoformat = not autoformat
    if autoformat then
        vim.api.nvim_echo({ { 'Enabled autoformat on save' } }, false, {})
    else
        vim.api.nvim_echo({ { 'Disabled autoformat on save' } }, false, {})
    end
end

nnoremap({
    '<leader>tf',
    function()
        require('config.lspconfig').toggle_format()
    end,
}) -- Toggle autoformat on save

---------- MAPPINGS ----------

local mappings = function()
    -- Telescope
    nnoremap({
        'gr',
        function()
            require('telescope.builtin').lsp_references()
        end,
    })
    nnoremap({
        'gd',
        function()
            require('telescope.builtin').lsp_definitions()
        end,
    })

    inoremap({
        '<C-s>',
        function()
            vim.lsp.buf.signature_help()
        end,
    })
    nnoremap({
        '<C-s>',
        function()
            vim.lsp.buf.signature_help()
        end,
    })
    nnoremap({
        'gh',
        function()
            vim.lsp.buf.hover()
        end,
    })
    nnoremap({
        'gR',
        function()
            vim.lsp.buf.rename()
        end,
    })
    nnoremap({
        '<leader>ca',
        function()
            vim.lsp.buf.code_action()
        end,
    })
    nnoremap({
        'gp',
        function()
            vim.lsp.diagnostic.goto_prev()
        end,
    })
    nnoremap({
        'gn',
        function()
            vim.lsp.diagnostic.goto_next()
        end,
    })
    nnoremap({
        '<leader>cd',
        function()
            vim.lsp.diagnostic.show_line_diagnostics()
        end,
    })

    nnoremap({ 'gb', '<C-t>' })
    vnoremap({ 'gb', '<C-t>' })

    autocmd({
        event = 'BufWritePre',
        pattern = { '*.tsx', '*.ts', '*.js', '*.vue', '*.lua' },
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
        { 'LspDiagnosticsSignError', { text = '✘', texthl = 'LspDiagnosticsSignError' } }
    )
    vim.api.nvim_call_function('sign_define', {
        'LspDiagnosticsSignWarning',
        { text = '', texthl = 'LspDiagnosticsSignWarning' },
    })
    vim.api.nvim_call_function(
        'sign_define',
        { 'LspDiagnosticsSignHint', { text = '', texthl = 'LspDiagnosticsSignHint' } }
    )
    -- vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}})

    require('lspkind').init()
end

local make_config = function()
    return {
        on_attach = function(client)
            require('config.lspconfig.handlers').handlers()
            mappings()
            signs()
            require('config.lspconfig.signature').setup()
            if client.name == 'typescript' or client.name == 'lua' then
                client.resolved_capabilities.document_formatting = false
            end
            if client.name == 'efm' then
                client.resolved_capabilities.document_formatting = true
            end
        end,
        -- on_attach = function()
        --     require('lsp_signature').on_attach({
        --         bind = true,
        --         hint_enable = false,
        --         hi_parameter = 'Title',
        --         fix_pos = true,
        --     })
        -- end,
    }
end

-- Automatic setup for language servers
local setup_servers = function()
    if package.loaded['lspinstall'] then
        return
    end
    require('lspinstall').setup()
    local servers = require('lspinstall').installed_servers()
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
end

setup_servers()

-- Reload after install
require('lspinstall').post_install_hook = function()
    setup_servers()
    vim.cmd('bufdo e')
end

return M
