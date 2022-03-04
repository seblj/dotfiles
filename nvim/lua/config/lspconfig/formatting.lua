local M = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local nls_has_formatter = function(ft)
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

local disable_formatters = {
    'vuels',
    'volar',
    'tsserver',
}

local format_languages = {
    'typescriptreact',
    'typescript',
    'javascript',
    'javascriptreact',
    'vue',
    'lua',
    'go',
    'rust',
    'json',
    'markdown',
    'toml',
}

M.setup = function(client)
    local autoformat = true
    vim.keymap.set('n', '<leader>tf', function()
        autoformat = not autoformat
        if autoformat then
            vim.api.nvim_echo({ { 'Enabled autoformat on save' } }, false, {})
        else
            vim.api.nvim_echo({ { 'Disabled autoformat on save' } }, false, {})
        end
    end, { desc = 'Lsp: Toggle format', buffer = true })

    local ft = vim.api.nvim_buf_get_option(0, 'ft')
    if vim.tbl_contains(disable_formatters, client.name) or nls_has_formatter(ft) and client.name ~= 'null-ls' then
        client.resolved_capabilities.document_formatting = false
    else
        client.resolved_capabilities.document_formatting = true
    end

    if client.resolved_capabilities.document_formatting then
        augroup('AutoFormat', {})
        autocmd('BufWritePre', {
            group = 'AutoFormat',
            buffer = 0,
            callback = function()
                if autoformat and vim.tbl_contains(format_languages, ft) then
                    vim.lsp.buf.formatting_sync()
                end
            end,
        })
    end
end

return M
