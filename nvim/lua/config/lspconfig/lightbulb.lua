local lsp_util = require('vim.lsp.util')
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local sign_name = 'LightbulbSign'
local sign_group = 'LightbulbGroup'
local old_line = {}
local M = {}

local config = {
    icon = '',
    diagnostic_only = true,
}

local changed_line = function()
    local line = vim.fn.line('.')
    if line == old_line[1] then
        return false
    end
    old_line = { line }
    return true
end

local handler = function(results, ctx)
    local num_results = results[1].result and #results[1].result or 0
    if num_results == 0 then
        vim.fn.sign_unplace(sign_group)
        return
    end
    -- Only show actions if there are diagnostics
    if config.diagnostic_only and #vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 }) == 0 then
        vim.fn.sign_unplace(sign_group)
        return
    end

    if changed_line() then
        vim.fn.sign_unplace(sign_group)
    end
    vim.fn.sign_place(0, sign_group, sign_name, ctx.bufnr, { lnum = vim.fn.line('.'), priority = 1000 })
end

local check_code_action = function()
    if vim.fn.mode() ~= 'n' then
        return
    end
    local context = {
        diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 }),
    }
    local params = lsp_util.make_range_params()
    params.context = context
    local bufnr = vim.api.nvim_get_current_buf()
    local method = 'textDocument/codeAction'
    vim.lsp.buf_request_all(bufnr, method, params, function(results)
        handler(results, { bufnr = bufnr, method = method, params = params })
    end)
end

M.setup = function()
    vim.fn.sign_define(sign_name, { text = config.icon, texthl = 'DiagnosticInfo' })

    local group = augroup('SetupLightbulb', { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, pattern = '<buffer>' })
    autocmd({ 'CursorHold', 'CursorMoved' }, {
        group = group,
        pattern = '<buffer>',
        callback = function()
            -- Guard against spamming of method not supported after
            -- stopping a language serer with LspStop
            local active_clients = vim.lsp.get_active_clients()
            if #active_clients < 1 then
                return
            end
            check_code_action()
        end,
        desc = 'Start lightbulb for code actions',
    })
end

return M
