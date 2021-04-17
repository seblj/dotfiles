---------- LSP CONFIG ----------

local lspconfig = require('lspconfig')
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
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- map('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
-- map('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
-- map('n', '<leader>ca', '<cmd>vim.lsp.buf.code_action()<CR>')
-- map('n', 'gh', '<cmd>vim.lsp.buf.hover()<CR>')
-- map('n', 'gR', '<cmd>vim.lsp.buf.rename()<CR>')
-- map('n', 'gr', '<cmd>vim.lsp.buf.references()<CR>')

-- Telescope
map('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>')

-- Lspsaga
-- cmd("autocmd CursorHold * lua require('lspsaga.diagnostic').show_line_diagnostics()")
-- map('i', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
-- map('n', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')
-- map('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
-- map('n', 'gh', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>')
-- map('n', 'gR', '<cmd>lua require("lspsaga.rename").rename()<CR>')
-- map('n', '<Esc>', '<cmd>lua require("lspsaga.rename").close_rename_win()<CR>')

map('n', 'gb', '<C-t>')
map('v', 'gb', '<C-t>')


---------- DIAGNOSTICS ----------

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    -- virtual_text = {
    --     severity_limit = 'Warning',
    -- },
    signs = true,
    update_in_insert = false,
}
)

---------- SIGNS ----------

vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignError", {text = "✘", texthl = "LspDiagnosticsSignError"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"}})
-- vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}})

-- require('lspkind').init()


---------- LANGUAGE SERVERS ----------

lspconfig.clangd.setup {}               -- C
lspconfig.rust_analyzer.setup{}         -- Rust
lspconfig.bashls.setup{}                -- Bash
lspconfig.jsonls.setup{}                -- JSON
lspconfig.html.setup{}                  -- HTML
lspconfig.vimls.setup{}                 -- Vimscript
lspconfig.cssls.setup{}                 -- CSS
lspconfig.texlab.setup{}                -- Latex
lspconfig.tsserver.setup{}              -- Typescript, tsx etc
lspconfig.vuels.setup{}                 -- Vue
lspconfig.pyls_ms.setup{                -- Python
    cmd = {"dotnet", "exec", "/Users/sebastianlyngjohansen/Applications/python-language-server/output/bin/Debug/Microsoft.Python.languageServer.dll" },
}

local pid = vim.fn.getpid()
local omnisharp_bin = "/Users/sebastianlyngjohansen/Applications/omnisharp-osx/run"
lspconfig.omnisharp.setup{              -- C#
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
}
lspconfig.sqlls.setup{                  -- SQL
    cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"};
}

lspconfig.sumneko_lua.setup {           -- Lua
    cmd = {'/Users/sebastianlyngjohansen/Applications/lua-language-server/bin/macOS/lua-language-server', "-E", '/Users/sebastianlyngjohansen/Applications/lua-language-server' .. "/main.lua"};
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
