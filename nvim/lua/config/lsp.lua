---------- LSP CONFIG ----------

local lspconfig = require('lspconfig')
local utils = require'utils'
local cmd, map = vim.cmd, utils.map

cmd("autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()")
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>')

map('n', 'gb', '<C-t>')
map('v', 'gb', '<C-t>')


---------- DIAGNOSTICS ----------

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
}
)

---------- SIGNS ----------

vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignError", {text = "✘", texthl = "LspDiagnosticsSignError"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}})


---------- LANGUAGE SERVERS ----------

lspconfig.clangd.setup {}
lspconfig.pyls_ms.setup{
    cmd = {"dotnet", "exec", "/Users/sebastianlyngjohansen/Applications/python-language-server/output/bin/Debug/Microsoft.Python.languageServer.dll" },
}
-- lspconfig.pyls.setup{
--     settings = { pyls = { plugins = {
--         pycodestyle = { enabled = false },
--         pylint = { enabled = false }
--     } } }
-- }
local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = "/Users/sebastianlyngjohansen/Applications/omnisharp-osx/run"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
require'lspconfig'.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
}
lspconfig.vimls.setup{}
lspconfig.cssls.setup{}
lspconfig.texlab.setup{}
lspconfig.html.setup{}
lspconfig.tsserver.setup{}
lspconfig.sqlls.setup{
    cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"};
}

require'lspconfig'.sumneko_lua.setup {
    cmd = {'/Users/sebastianlyngjohansen/Applications/lua-language-server/bin/macOS/lua-language-server', "-E", '/Users/sebastianlyngjohansen/Applications/lua-language-server' .. "/main.lua"};
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
}


