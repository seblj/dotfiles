local M = {}
local ui = require('config.lspconfig.ui')
local codeactions, bufnr

M.confirm = function()
    local num = tonumber(vim.fn.expand('<cword>'))
    local action_chosen = codeactions[num]

    if action_chosen.edit or type(action_chosen.command) == "table" then
        if action_chosen.edit then
            vim.lsp.util.apply_workspace_edit(action_chosen.edit)
        end
        if type(action_chosen.command) == "table" then
            vim.lsp.buf_request(bufnr, 'workspace/executeCommand', action_chosen.command)
        end
    else
        vim.lsp.buf_request(bufnr, 'workspace/executeCommand', action_chosen)
    end
    vim.api.nvim_win_close(0, true)
end

M.codeaction = function(_, _, actions)
    bufnr = vim.fn.bufnr()
    codeactions = actions
    if actions == nil or vim.tbl_isempty(actions) then
        print("No code actions available")
        return
    end
    local contents = {}
    for i, action in ipairs(actions) do
        local a = action.title:gsub('\r\n', '\\r\\n')
        a = a:gsub('\n', '\\n')
        table.insert(contents, string.format("[%d] %s", i, a))
    end

    ui.popup_create({
        title = "Code Actions:",
        lines = contents,
        hide_cursor = true,
        limit_cursor = true,
        enter = true,
    })
    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<cmd>lua require("config.lspconfig.codeaction").confirm()<CR>', {silent = true})
end

return M
