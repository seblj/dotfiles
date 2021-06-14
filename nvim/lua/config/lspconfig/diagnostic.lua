local M = {}
local ui = require('seblj.utils.ui')

M.show_line_diagnostics = function()
    local lines = {}
    local highlights = {}

    local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    if vim.tbl_isempty(line_diagnostics) then
        return
    end

    for i, diagnostic in ipairs(line_diagnostics) do
        local prefix = string.format('%d. ', i)
        local hiname = vim.lsp.diagnostic._get_floating_severity_highlight_name(diagnostic.severity)
        assert(hiname, 'unknown severity: ' .. tostring(diagnostic.severity))

        local message_lines = vim.split(diagnostic.message, '\n', true)
        table.insert(lines, prefix .. message_lines[1])
        table.insert(highlights, { #prefix, hiname })
        for j = 2, #message_lines do
            table.insert(lines, message_lines[j])
            table.insert(highlights, { 0, hiname })
        end
    end

    local width = ui.calculate_width(lines)
    lines = { 'Diagnostics: ', string.rep(ui.border_line, width), unpack(lines) }
    local popup_bufnr, winnr = ui.popup_create({
        lines = lines,
        focus_id = 'line_diagnostics',
    })
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)

    for i, hi in ipairs(highlights) do
        local prefixlen, hiname = unpack(hi)
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i + 1, prefixlen, -1)
    end

    return popup_bufnr, winnr
end

return M
