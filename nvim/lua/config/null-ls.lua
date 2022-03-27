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
        -- formatter.prettierd.with({
        --     condition = function()
        --         local bufnr = vim.api.nvim_get_current_buf()
        --         local bufname = vim.api.nvim_buf_get_name(bufnr)
        --         local eslint_root_dir = require('lspconfig.server_configurations.eslint').default_config.root_dir
        --         return not eslint_root_dir(lsp_util.path.sanitize(bufname), bufnr)
        --     end,
        -- }),
    },
    on_attach = function(client)
        formatting.setup(client)
    end,
})
