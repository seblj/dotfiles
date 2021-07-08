local M = {}

M.options = {
    hi_parameter = 'Title',
    max_width = 120,
    max_height = 12,
}

local handler_config = {
    check_pumvisible = true,
}

local match_parameter = function(result)
    local signatures = result.signatures
    if #signatures == 0 then
        return nil
    end

    local signature = signatures[1]
    if not signature.parameters then
        return nil
    end

    -- Don't highlight paramter if there is less than 2
    if #signature.parameters < 2 then
        return nil
    end

    local activeParameter = signature.activeParameter or result.activeParameter
    if not activeParameter then
        return nil
    end

    local nextParameter = signature.parameters[activeParameter + 1]
    if not nextParameter then
        return nil
    end

    local parameter = signature.parameters[1]
    if not parameter or not parameter.label then
        return nil
    end

    if type(parameter.label) == 'string' then
        return signature.label:find(nextParameter.label, 1, true)
    elseif type(parameter.label) == 'table' then
        return nextParameter.label[1] + 1, nextParameter.label[2]
    end
end

M.handler = function(_, _, result, _, bufnr, config)
    config = config or {}
    if not result then
        return
    end
    if config.check_pumvisible and vim.fn.pumvisible() ~= 0 then
        return
    end
    local s, l = match_parameter(result)

    local ft = vim.api.nvim_buf_get_option(bufnr, 'ft')
    vim.api.nvim_win_set_option(0, 'winhl', 'Normal:Normal')

    local lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result, ft)
    if not lines then
        return
    end
    lines = vim.lsp.util.trim_empty_lines(lines)

    config.border = 'rounded'
    config.max_width = M.options.max_width
    config.max_height = M.options.max_height

    local fbufnr, _ = vim.lsp.util.open_floating_preview(lines, 'markdown', config)

    local ns = vim.api.nvim_create_namespace('signature')
    local hi = M.options.hi_parameter
    if s and l then
        vim.api.nvim_buf_set_extmark(fbufnr, ns, 0, s - 1, { end_line = 0, end_col = l, hl_group = hi })
    end
end

local check_trigger_char = function(line_to_cursor, triggers)
    if not triggers then
        return false
    end

    for _, trigger_char in ipairs(triggers) do
        local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
        local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
        if current_char == trigger_char then
            return true
        end
        if current_char == ' ' and prev_char == trigger_char then
            return true
        end
    end
    return false
end

M.open_signature = function()
    local clients = vim.lsp.buf_get_clients(0)
    local triggered = false

    for _, client in pairs(clients) do
        if not client.server_capabilities.signatureHelpProvider then
            return
        end
        local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

        -- csharp has wrong trigger chars for some odd reason
        if client.name == 'csharp' then
            triggers = { '(', ',' }
        end

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local line_to_cursor = line:sub(1, pos[2])

        if not triggered then
            triggered = check_trigger_char(line_to_cursor, triggers)
        end
    end

    if triggered then
        local params = vim.lsp.util.make_position_params()
        local handler = vim.lsp.with(M.handler, handler_config)
        vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, handler)
    end
end

M.setup = function(config)
    vim.cmd('augroup Signature')
    vim.cmd('autocmd! * <buffer>')
    vim.cmd('autocmd TextChangedI * lua require("config.lspconfig.signature").open_signature()')
    vim.cmd('augroup end')

    M.options = vim.tbl_extend('force', config, M.options)
end

return M
