local M = {}
local ui = require('seblj.utils.ui')
local utils = require('seblj.utils')
local autocmd = utils.autocmd
local nnoremap = vim.keymap.nnoremap
local codeactions, bufnr

M.confirm = function(key)
    local num = tonumber(vim.fn.expand('<cword>'))
    if key then
        num = key
    end
    local action_chosen = codeactions[num]

    if action_chosen.edit or type(action_chosen.command) == 'table' then
        if action_chosen.edit then
            vim.lsp.util.apply_workspace_edit(action_chosen.edit)
        end
        if type(action_chosen.command) == 'table' then
            vim.lsp.buf_request(bufnr, 'workspace/executeCommand', action_chosen.command)
        end
    else
        vim.lsp.buf_request(bufnr, 'workspace/executeCommand', action_chosen)
    end
    vim.api.nvim_win_close(0, true)
end

M.handler = function(_, _, actions)
    bufnr = vim.fn.bufnr()
    codeactions = actions
    if actions == nil or vim.tbl_isempty(actions) then
        print('No code actions available')
        return
    end
    local lines = {}
    for i, action in ipairs(actions) do
        local a = action.title:gsub('\r\n', '\\r\\n')
        a = a:gsub('\n', '\\n')
        table.insert(lines, string.format('[%d] %s', i, a))
    end

    local width = ui.calculate_width(lines)
    local title = 'Code Actions: '
    lines = { title, string.rep(ui.border_line, width), unpack(lines) }

    local popup_bufnr, winnr = ui.popup_create({
        lines = lines,
        enter = true,
    })
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #title)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)
    vim.api.nvim_win_set_cursor(winnr, { 3, 1 })
    vim.api.nvim_win_set_option(winnr, 'cursorline', true)
    require('seblj.utils').setup_hidden_cursor()
    require('seblj.utils').hide_cursor()

    -- Keymap for selecting option with number
    for k, _ in ipairs(lines) do
        if k > 2 then
            nnoremap({
                string.format('%d', k - 2),
                function()
                    M.confirm(k - 2)
                end,
                buffer = true,
            })
        end
    end

    autocmd({
        event = 'CursorMoved',
        pattern = '<buffer>',
        command = function()
            require('seblj.utils.ui').set_cursor()
        end,
    })
    nnoremap({ '<CR>', M.confirm, buffer = true })
end

return M
