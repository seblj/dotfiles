---------- LSP CONFIG ----------

local utils = require('seblj.utils')
local cmd, map = vim.cmd, utils.map

---------- MAPPINGS ----------

-- Telescope
map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>')
map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>')

map('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', 'gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', 'gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

map('n', 'gb', '<C-t>')
map('v', 'gb', '<C-t>')

-- cmd([[autocmd CursorHold * lua require('echo-diagnostics').echo_line_diagnostic()]])
-- cmd([[nnoremap <leader>cd <cmd>lua require("echo-diagnostics").echo_entire_diagnostic()<CR>]])

---------- DIAGNOSTICS ----------

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
    }
)

---------- OVERWRITES ----------

vim.lsp.handlers["textDocument/hover"] = require('config.lspconfig.hover').handler
vim.lsp.handlers["textDocument/codeAction"] = require('config.lspconfig.codeaction').handler
vim.lsp.handlers["textDocument/signatureHelp"] = require('config.lspconfig.signature').handler
vim.lsp.buf.rename = require('config.lspconfig.rename').rename
vim.lsp.diagnostic.show_line_diagnostics = require('config.lspconfig.diagnostic').show_line_diagnostics

---------- SIGNS ----------

vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignError", {text = "✘", texthl = "LspDiagnosticsSignError"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"}})
-- vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}})

require('lspkind').init()


---------- LANGUAGE SERVERS ----------

-- Language specific settings
local lua_settings = {
    Lua = {
        runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
        },
        diagnostics = {
            globals = {'vim'},
        },
        workspace = {
            library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
        },
    },
}
local python_settings = {
    python = {
        analysis = {
            typeCheckingMode = 'off'
        }
    }
}
local clang_filetypes = {"c", "cpp", "objc", "objcpp", "cuda"}

local fs_cmd = {'dotnet', '/Users/sebastianlyngjohansen/Applications/FsAutoComplete-0.45.4/bin/release_netcore/fsautocomplete.dll', '--background-service-enabled'}

local make_config = function()
    return {
        -- Needs to be inside a function or else setup is called even though no lsp is attached
        on_attach = function()
            require('config.lspconfig.signature').setup{}
        end
        -- on_attach = function()
        --     require('lsp_signature').on_attach{
        --         bind = true,
        --         hint_enable = false,
        --         hi_parameter = "Title",
        --     }
        -- end
    }
end

local user_servers = {'fsautocomplete'}

-- Automatic setup for language servers
local setup_servers = function()
    if package.loaded['lspinstall'] then return end
    require('lspinstall').setup()
    local servers = require('lspinstall').installed_servers()
    servers = vim.tbl_extend('force', servers, user_servers)
    for _, server in pairs(servers) do
        local config = make_config()

        if server == 'lua' then config.settings = lua_settings end
        if server == 'python' then config.settings = python_settings end
        if server == 'cpp' then config.filetypes = clang_filetypes end
        if server == 'fsautocomplete' then config.cmd = fs_cmd end

        require('lspconfig')[server].setup(config)
    end
end

setup_servers()

-- Reload after install
require('lspinstall').post_install_hook = function()
    setup_servers()
    cmd("bufdo e")
end
