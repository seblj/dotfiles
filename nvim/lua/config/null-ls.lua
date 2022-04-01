local nls = require('null-ls')
local formatting = require('config.lspconfig.formatting')
local formatter = nls.builtins.formatting
local lsp_util = require('lspconfig.util')

nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
        formatter.stylua,
        formatter.goimports,
        formatter.prettierd.with({
            -- I hate that this only runs on the first attach of a buffer
            -- Would have been a lot easier if this actually ran on every buffer attach
            -- to see if null-ls should attach or not. But because it only runs once, which
            -- means that if a random file is opened first, and then in the same session
            -- a file that uses eslint is opened, it will attach null-ls to use prettierd
            -- even though this function returns false.
            condition = function()
                return not formatting.eslint_attach()
            end,
        }),
    },
    on_attach = function(client)
        formatting.setup(client)
    end,
})
