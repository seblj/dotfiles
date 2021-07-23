---------- LSP CONFIG ----------

local utils = require('seblj.utils')
local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap
local inoremap = map.inoremap
local vnoremap = map.vnoremap
local autocmd = utils.autocmd

---------- MAPPINGS ----------

-- Telescope
nnoremap({ 'gr', require('telescope.builtin').lsp_references })
nnoremap({ 'gd', require('telescope.builtin').lsp_definitions })

inoremap({ '<C-s>', vim.lsp.buf.signature_help })
nnoremap({ '<C-s>', vim.lsp.buf.signature_help })
nnoremap({ 'gh', vim.lsp.buf.hover })
nnoremap({
    'gR',
    function()
        vim.lsp.buf.rename()
    end,
})
nnoremap({ '<leader>ca', vim.lsp.buf.code_action })
nnoremap({ 'gp', vim.lsp.diagnostic.goto_prev })
nnoremap({ 'gn', vim.lsp.diagnostic.goto_next })
nnoremap({ '<leader>cd', vim.lsp.diagnostic.show_line_diagnostics })

nnoremap({ 'gb', '<C-t>' })
vnoremap({ 'gb', '<C-t>' })

-- autocmd({
--     event = 'CursorHold',
--     pattern = '*',
--     command = function()
--         require('echo-diagnostics').echo_line_diagnostic()
--     end,
-- })
-- nnoremap({ '<leader>cd', require('echo-diagnostics').echo_entire_diagnostic })

---------- DIAGNOSTICS ----------

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
})

---------- OVERWRITES ----------

local override = function(handler, override_config)
    return function(opts, bufnr, line_nr, client_id)
        return handler(vim.tbl_deep_extend('force', opts or {}, override_config), bufnr, line_nr, client_id)
    end
end

vim.lsp.handlers['textDocument/codeAction'] = require('config.lspconfig.codeaction').handler
vim.lsp.buf.rename = require('config.lspconfig.rename').rename
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
    silent = true,
    focusable = false, -- Sometimes gets set to true if not set explicitly to false for some reason
})
vim.lsp.diagnostic.show_line_diagnostics = override(vim.lsp.diagnostic.show_line_diagnostics, {
    border = 'rounded',
})

---------- SIGNS ----------

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

---------- LANGUAGE SERVERS ----------

local lsp_settings = {
    vue = {
        init_options = {
            config = {
                vetur = {
                    completion = {
                        autoImport = true,
                        useScaffoldSnippets = false,
                    },
                },
            },
        },
    },

    lua = require('lua-dev').setup({
        library = {
            plugins = false,
        },
    }),

    python = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = 'off',
                },
            },
        },
    },

    cpp = {
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    },

    html = {
        filetypes = { 'html' },
    },

    fsautocomplete = {
        cmd = {
            'dotnet',
            '/Users/sebastianlyngjohansen/Applications/FsAutoComplete-0.45.4/bin/release_netcore/fsautocomplete.dll',
            '--background-service-enabled',
        },
    },
}

local make_config = function()
    return {
        -- Needs to be inside a function or else setup is called even though no lsp is attached
        on_attach = function(client)
            require('config.lspconfig.signature').setup()
            if client.name == 'typescript' then
                client.resolved_capabilities.document_formatting = false
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

local user_servers = { 'fsautocomplete' }

-- Automatic setup for language servers
local setup_servers = function()
    if package.loaded['lspinstall'] then
        return
    end
    require('lspinstall').setup()
    local servers = require('lspinstall').installed_servers()
    servers = vim.tbl_extend('force', servers, user_servers)
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

local eslint = {
    lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { '%f:%l:%c: %m' },
    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
    formatStdin = true,
}

local prettier = {
    formatCommand = 'prettierd ${INPUT}',
    formatStdin = true,
}

require('lspconfig').efm.setup({
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
    end,
    root_dir = require('lspconfig.util').root_pattern('.eslintrc*', 'package.json'),
    settings = {
        languages = {
            javascript = { prettier, eslint },
            javascriptreact = { prettier, eslint },
            typescript = { prettier, eslint },
            typescriptreact = { prettier, eslint },
            vue = { prettier, eslint },
        },
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
    },
})

autocmd({
    event = 'BufWritePre',
    pattern = { '*.tsx', '*.ts', '*.js', '*.vue' },
    command = function()
        vim.lsp.buf.formatting_sync()
    end,
})
