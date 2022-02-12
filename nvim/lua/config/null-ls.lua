local M = {}

local nls = require('null-ls')
local formatter = nls.builtins.formatting
local lsp_util = require('lspconfig.util')

nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
        formatter.stylua,
        formatter.goimports,
        formatter.prettierd.with({
            condition = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                local eslint_root_dir = require('lspconfig.server_configurations.eslint').default_config.root_dir
                return not eslint_root_dir(lsp_util.path.sanitize(bufname), bufnr)
            end,
        }),
    },
})

function M.has_formatter(ft)
    local config = require('null-ls.config').get()
    for _, source in ipairs(config.sources) do
        if vim.tbl_contains(source.filetypes, ft) then
            if source.condition then
                local utils = require('null-ls.utils').make_conditional_utils()
                return source.condition(utils)
            end
            if type(source.method) == 'string' and source.method == 'NULL_LS_FORMATTING' then
                return true
            elseif type(source.method) == 'table' and vim.tbl_contains(source.method, 'NULL_LS_FORMATTING') then
                return true
            end
        end
    end
    return false
end

return M
