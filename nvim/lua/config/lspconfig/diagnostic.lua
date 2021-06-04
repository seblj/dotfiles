local M = {}
local ui = require('config.lspconfig.ui')

M.line_diagnostics = function()
    local opts = {}

    local lines = {}
    local highlights = {}

    local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    if vim.tbl_isempty(line_diagnostics) then return end

    for i, diagnostic in ipairs(line_diagnostics) do
        local prefix = string.format("%d. ", i)
        local hiname = vim.lsp.diagnostic._get_floating_severity_highlight_name(diagnostic.severity)
        assert(hiname, 'unknown severity: ' .. tostring(diagnostic.severity))

        local message_lines = vim.split(diagnostic.message, '\n', true)
        table.insert(lines, prefix..message_lines[1])
        table.insert(highlights, {#prefix, hiname})
        for j = 2, #message_lines do
            table.insert(lines, message_lines[j])
            table.insert(highlights, {0, hiname})
        end
    end

    opts.border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
    opts.focus_id = "line_diagnostics"
    local width = ui.calculate_width(lines)
    lines = { "Diagnostics: ", string.rep('─', width), unpack(lines) }
    local popup_bufnr, winnr = vim.lsp.util.open_floating_preview(lines, 'plaintext', opts)
    vim.api.nvim_win_set_option(winnr, "winhl","Normal:Normal")
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)

    for i, hi in ipairs(highlights) do
        local prefixlen, hiname = unpack(hi)
        -- Start highlight after the prefix
        vim.api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i+1, prefixlen, -1)
    end

    return popup_bufnr, winnr
end

return M
