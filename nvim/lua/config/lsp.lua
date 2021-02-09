---------- LSP CONFIG ----------

local lspconfig = require('lspconfig')

local cmd = vim.cmd
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

cmd("autocmd CursorHold,CursorMoved * lua vim.lsp.diagnostic.show_line_diagnostics()")
-- cmd("autocmd CursorMoved * lua vim.lsp.diagnostic.show_line_diagnostics()")

map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

lspconfig.clangd.setup {}
lspconfig.pyls.setup{
    settings = { pyls = { plugins = {
        pycodestyle = { enabled = false },
        pylint = { enabled = false }
    } } }
}
lspconfig.vimls.setup{}
lspconfig.texlab.setup{}
lspconfig.html.setup{}
lspconfig.tsserver.setup{}
-- lspconfig.denols.setup{
--     init_options = {
--       enable = true,
--       lint = true,
--       unstable = false
--     }}
lspconfig.sqlls.setup{
    cmd = {"/usr/local/bin/sql-language-server", "up", "--method", "stdio"};
}

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
  cmd = {'/Users/sebastianlyngjohansen/programs/lua-language-server/bin/macOS/lua-language-server', "-E", '/Users/sebastianlyngjohansen/programs/lua-language-server' .. "/main.lua"};
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    -- virtual_text = {
    --     prefix = '~',
    -- },
    virtual_text = false,
    signs = true,
    update_in_insert = false,
}
)

vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignError", {text = "✘", texthl = "LspDiagnosticsSignError"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"}})


