local M = {}

M.nls_setup = function()
    local nls = require('null-ls')
    local formatter = nls.builtins.formatting
    nls.setup({
        debounce = 150,
        save_after_format = false,
        sources = {
            formatter.stylua,
            formatter.goimports,
            formatter.prettierd.with({
                condition = function(utils)
                    return not utils.root_has_file('.eslintrc.js')
                end,
            }),
        },
    })
end

function M.nls_has_formatter(ft)
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
