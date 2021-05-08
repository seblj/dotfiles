---------- LSP CONFIG ----------

local utils = require('seblj.utils')
local cmd, map = vim.cmd, utils.map

---------- MAPPINGS ----------

-- Telescope
map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>')
map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>')

-- Lspsaga
map('n', '<leader>cd', '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>')
map('i', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
map('n', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
map('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
map('n', 'gh', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>')
map('n', 'gR', '<cmd>lua require("lspsaga.rename").rename()<CR>')
map('n', '<Esc>', '<cmd>lua require("lspsaga.rename").close_rename_win()<CR>')
map('n', 'gp', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>')
map('n', 'gn', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>')

map('n', 'gb', '<C-t>')
map('v', 'gb', '<C-t>')


---------- DIAGNOSTICS ----------

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
    }
)

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


local make_config = function()
    return {
        on_attach = require('lsp_signature').on_attach{}
    }
end

-- Automatic setup for language servers
local setup_servers = function()
    if package.loaded['lspinstall'] then return end
    require'lspinstall'.setup()
    local servers = require('lspinstall').installed_servers()
    for _, server in pairs(servers) do
        local config = make_config()

        if server == 'lua' then config.settings = lua_settings end
        if server == 'python' then config.settings = python_settings end

        require('lspconfig')[server].setup(config)
    end
end

setup_servers()

-- Reload after install
require('lspinstall').post_install_hook = function()
    setup_servers()
    cmd("bufdo e")
end

-- Options and language servers lspinstall can't install

require('lspconfig').sqlls.setup{                   -- SQL
    cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"};
}
