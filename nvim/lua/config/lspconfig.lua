---------- LSP CONFIG ----------

local utils = require('seblj.utils')
local cmd, map = vim.cmd, utils.map

---------- MAPPINGS ----------

-- Hover diagnostic
-- cmd("autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()")
-- map('n', '<leader>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

-- Echo diagnostic
-- cmd("autocmd CursorHold * lua require('echo-diagnostics').echo_line_diagnostic()")
-- map('n', '<leader>cd', '<cmd>lua require("echo-diagnostics").echo_entire_diagnostic()<CR>')

-- Default
-- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- map('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
-- map('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
-- map('n', '<leader>ca', '<cmd>vim.lsp.buf.code_action()<CR>')
-- map('n', 'gh', '<cmd>vim.lsp.buf.hover()<CR>')
-- map('n', 'gR', '<cmd>vim.lsp.buf.rename()<CR>')
-- map('n', 'gr', '<cmd>vim.lsp.buf.references()<CR>')
-- map('n', 'gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
-- map('n', 'gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')

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

-- Automatic setup for language servers
require'lspinstall'.setup() -- important
local setup_servers = function()
    require('lspinstall').setup()
    local servers = require('lspinstall').installed_servers()
    for _, server in pairs(servers) do
        require('lspconfig')[server].setup{
            on_attach = function()
                require('lsp_signature').on_attach{}
            end
        }
    end
end

setup_servers()

-- Reload after install
require('lspinstall').post_install_hook = function()
    setup_servers()
    vim.cmd("bufdo e")
end

-- Options and language servers lspinstall can't install

require('lspconfig').sqlls.setup{                   -- SQL
    cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"};
}
require('lspconfig').python.setup{                  -- Python
    settings = {
        python = {
            analysis = {
                typeCheckingMode = 'off'
            }
        }
    }
}
require('lspconfig').lua.setup{                     -- Lua
    settings = {
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
    },
}
