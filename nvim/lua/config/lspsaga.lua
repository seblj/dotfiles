---------- LSPSAGA CONFIG ----------

require('lspsaga').init_lsp_saga {
    code_action_prompt = {
        enable = false
    },
    code_action_keys = {
        quit = '<esc>',exec = '<CR>'
    },
    use_saga_diagnostic_sign = false,
    border_style = "round"
}

-- Signature help
local M = {}

M.check_trigger_char = function(line_to_cursor, triggers)
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

M.open_signature_help = function()
    local clients = vim.lsp.buf_get_clients(0)
    local triggered = false

    for _, client in pairs(clients) do
        if not client.server_capabilities.signatureHelpProvider then
            return
        end
        local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local line_to_cursor = line:sub(1, pos[2])

        if not triggered then
            triggered = M.check_trigger_char(line_to_cursor, triggers)
        end
    end

    if triggered then
        vim.defer_fn(require('lspsaga.signaturehelp').signature_help, 100)
    end
end

return M
