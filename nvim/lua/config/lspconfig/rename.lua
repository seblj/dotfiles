local M = {}
local pos = {}
local ui = require('config.lspconfig.ui')

local options = {
    prompt = '> '
}

M.confirm = function()
    local new_name = vim.trim(vim.fn.getline('.'):sub(#options.prompt+1, -1))
    vim.api.nvim_win_close(0, true)
    if not vim.tbl_isempty(pos) then
        vim.api.nvim_win_set_cursor(0, pos)
    end
    pos = {}
    local params = vim.lsp.util.make_position_params()
    local current_name = vim.fn.expand('<cword>')
    vim.cmd('stopinsert')
    if not (new_name and #new_name > 0) or new_name == current_name then
        return
    end
    params.newName = new_name
    vim.lsp.buf_request(0,'textDocument/rename', params)
end

M.rename = function()

    pos[1], pos[2] = vim.fn.line('.'),vim.fn.col('.')
    ui.popup_create({
        modifiable = true,
        enter = true,
        prompt = {
            enable = true,
            prefix = options.prompt
        }
    })
    vim.api.nvim_buf_set_keymap(0, 'i', '<CR>', '<cmd>lua require("config.lspconfig.rename").confirm()<CR>', {silent = true})
    vim.cmd('startinsert')
end

return M
