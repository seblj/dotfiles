local M = {}

M.nls_setup = function()
    local nls = require('null-ls')
    local formatter = nls.builtins.formatting
    local diagnostics = nls.builtins.diagnostics
    nls.config({
        debounce = 150,
        save_after_format = false,
        sources = {
            -- formatter.prettierd,
            formatter.stylua,
            formatter.eslint_d,
            formatter.goimports,
            diagnostics.eslint_d,
        },
    })
end

-- Gotten from folke's config
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/lsp/formatting.lua
function M.nls_has_formatter(ft)
    local config = require('null-ls.config').get()
    local formatters = config._generators['NULL_LS_FORMATTING']
    for _, f in ipairs(formatters) do
        if vim.tbl_contains(f.filetypes, ft) then
            return true
        end
    end
end

return M
