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
    old_line = {}
    table.insert(old_line, line)
    return true
end

local remove_icon = function()
    M.icon_opts.showing = false
    vim.fn.sign_unplace(sign_group)
end

local set_icon = function()
    if changed_line() then
        remove_icon()
    end
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.fn.line('.')
    M.icon_opts.showing = true
    vim.fn.sign_place(0, sign_group, sign_name, bufnr, { lnum = line, priority = 1000 })
end

local get_line_diagnostics = function()
    local diagnostics = {}
    local buffer_diagnostics = vim.diagnostic.get(0)
    local lnum = vim.fn.line('.')
    for _, v in pairs(buffer_diagnostics) do
        if lnum == v.lnum + 1 then
            table.insert(diagnostics, v)
        end
    end
    return diagnostics
end

local handler = function(results, ctx)
    local action_tuples = {}
    for client_id, result in pairs(results) do
        for _, action in pairs(result.result or {}) do
            table.insert(action_tuples, { client_id, action })
        end
    end
    -- No actions
    if #action_tuples == 0 then
        remove_icon()
        return
    end
    -- Only show actions if there are diagnostics
    if config.diagnostic_only then
        local diagnostics = get_line_diagnostics()
        if #diagnostics == 0 then
            remove_icon()
            return
        end
    end

    M.icon_opts.num_actions = #action_tuples
    set_icon()
end

M.check_code_action = function()
    if vim.fn.mode() ~= 'n' then
        return
    end
    local context = {}
    if not context.diagnostics then
        context.diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    end
    local params = lsp_util.make_range_params()
    params.context = context
    local bufnr = vim.api.nvim_get_current_buf()
    local method = 'textDocument/codeAction'
    vim.lsp.buf_request_all(bufnr, method, params, function(results)
        handler(results, { bufnr = bufnr, method = method, params = params })
    end)
end

M.setup = function()
    -- If I want to use it in galaxyline for example
    M.icon_opts = {
        showing = false,
        num_actions = 0,
    }
    vim.fn.sign_define(sign_name, { text = config.icon, texthl = 'DiagnosticInfo' })

    -- No way yet to clear only inside buffer with lua api for autocmds
    vim.cmd([[
        augroup SetupLightbulb
            au! * <buffer>
            autocmd CursorHold,CursorMoved <buffer> lua require('config.lspconfig.lightbulb').check_code_action()
        augroup END
    ]])

    -- augroup('SetupLightbulb', {})
    -- autocmd({ 'CursorHold', 'CursorMoved' }, {
    --     group = 'SetupLightbulb',
    --     pattern = '<buffer>',
    --     callback = function()
    --         check_code_action()
    --     end,
    -- })
end

return M
