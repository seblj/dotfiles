local M = {}
local ui = require('seblj.utils.ui')
local inoremap = vim.keymap.inoremap

local options = {
    prompt = '> ',
}

local confirm = function()
    local new_name = vim.trim(vim.fn.getline('.'):sub(#options.prompt + 1, -1))
    vim.api.nvim_win_close(0, true)
    local params = vim.lsp.util.make_position_params()
    local current_name = vim.fn.expand('<cword>')
    vim.cmd('stopinsert')
    if not (new_name and #new_name > 0) or new_name == current_name then
        return
    end
    params.newName = new_name
    vim.lsp.buf_request(0, 'textDocument/rename', params)
end

M.rename = function()
    local popup_bufnr, _ = ui.popup_create({
        width = 30,
        height = 1,
        enter = true,
        prompt = {
            enable = true,
            prefix = options.prompt,
            highlight = 'LspRenamePrompt',
        },
    })
    vim.api.nvim_buf_set_option(popup_bufnr, 'modifiable', true)
    inoremap({
        '<CR>',
        function()
            confirm()
        end,
        buffer = true,
    })
    vim.cmd('startinsert')
end

return M
