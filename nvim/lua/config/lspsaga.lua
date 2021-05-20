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

M.check_trigger_char = function(line_to_cursor, trigger_character)
    if trigger_character == nil then
        return false
    end
    for _, ch in ipairs(trigger_character) do
        local current_char = string.sub(line_to_cursor, #line_to_cursor - #ch + 1, #line_to_cursor)
        if current_char == ch then
            return true
        end
        if current_char == " " and #line_to_cursor > #ch + 1 then
            local pre_char = string.sub(line_to_cursor, #line_to_cursor - #ch, #line_to_cursor - 1)
            if pre_char == ch then
                return true
            end
        end
    end
    return false
end

M.open_signature_help = function()
    local clients = vim.lsp.buf_get_clients(0)
    if clients == nil or clients == {} then return end

    local triggered = false
    for _, client in pairs(clients) do
        if not client.server_capabilities.signatureHelpProvider then
            return
        end
        local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local line_to_cursor = line:sub(1, pos[2])

        if triggered == false then
            triggered = M.check_trigger_char(line_to_cursor, triggers)
        end
            print()
    end

    if triggered then
        require('lspsaga.signaturehelp').signature_help()
    end
end

M.setup_lspsaga_signature = function()
    vim.cmd('augroup LspsagaSignatureHelp')
    vim.cmd('autocmd! * <buffer>')
    vim.cmd('autocmd InsertCharPre * lua require("config.lspsaga").open_signature_help()')
    vim.cmd('augroup end')
end

return M
