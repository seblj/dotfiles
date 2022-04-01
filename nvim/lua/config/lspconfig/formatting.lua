local M = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local lsp_util = require('lspconfig.util')

local nls_has_formatter = function(ft)
    local config = require('null-ls.config').get()
    for _, source in ipairs(config.sources) do
        if vim.tbl_contains(source.filetypes, ft) then
            if source.condition then
                return source.condition()
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

M.eslint_attach = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- Do not include package.json as root_pattern for eslint
    local eslint_root_dir = lsp_util.root_pattern(
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json'
    )
    return eslint_root_dir(lsp_util.path.sanitize(bufname), bufnr)
end

M.setup = function(client)
    vim.b.do_formatting = true
    vim.keymap.set('n', '<leader>tf', function()
        vim.b.do_formatting = not vim.b.do_formatting
        if vim.b.do_formatting then
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
    if client.name == 'null-ls' and M.eslint_attach() then
        client.resolved_capabilities.document_formatting = false
    end

    if client.resolved_capabilities.document_formatting then
        local group = augroup('AutoFormat', { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, pattern = '<buffer>' })
        autocmd('BufWritePre', {
            group = group,
            pattern = '<buffer>',
            callback = function()
                local _ft = vim.api.nvim_buf_get_option(0, 'ft')
                if vim.b.do_formatting and vim.tbl_contains(format_languages, _ft) then
                    vim.lsp.buf.formatting_sync()
                end
            end,
        })
    end
end

return M
