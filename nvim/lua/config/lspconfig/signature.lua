local utils = require('seblj.utils')
local augroup = utils.augroup
local M = {}

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

local open_signature = function(clients)
    local triggered = false

    for _, client in pairs(clients) do
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
        vim.lsp.buf.signature_help()
    end
end

M.setup = function()
    local all_clients = vim.lsp.buf_get_clients(0)
    local clients = {}
    for _, client in pairs(all_clients) do
        if client.server_capabilities.signatureHelpProvider then
            table.insert(clients, client)
        end
    end
    augroup('Signature', {
        event = 'TextChangedI',
        pattern = '*',
        command = function()
            open_signature(clients)
        end,
    })
end

return M
