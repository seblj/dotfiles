local M = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local format_languages = {
    'eslint',
    'rust_analyzer',
    'jsonls',
    'omnisharp',
}

M.setup = function(client)
    if vim.tbl_contains(format_languages, client.name) then
        local group = augroup('AutoFormat', { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, pattern = '<buffer>' })
        autocmd('BufWritePre', {
            group = group,
            pattern = '<buffer>',
            callback = function()
                if vim.b.do_formatting ~= false then
                    if client.name == 'eslint' then
                        vim.cmd('EslintFixAll')
                    else
                        vim.lsp.buf.formatting_sync()
                    end
                end
            end,
        })
    end
end

return M
