local M = {}
local ui = require('seblj.utils.ui')
local inoremap = vim.keymap.inoremap

local options = {
    prompt = '> ',
}

local request = function(method, params, handler)
    vim.validate({
        method = { method, 's' },
        handler = { handler, 'f', true },
    })
    return vim.lsp.buf_request(0, method, params, handler)
end

local confirm = function(params, new_name)
    local close = new_name == nil
    new_name = new_name or vim.trim(vim.fn.getline('.'):sub(#options.prompt + 1, -1))
    if close then
        vim.api.nvim_win_close(0, true)
    end
    local current_name = vim.fn.expand('<cword>')
    vim.cmd('stopinsert')
    if not (new_name and #new_name > 0) or new_name == current_name then
        return
    end
    params.newName = new_name
    vim.lsp.buf_request(0, 'textDocument/rename', params)
end

M.rename = function(new_name)
    local params = vim.lsp.util.make_position_params()
    if new_name then
        confirm(params, new_name)
        return
    end
    local prepare_rename = function(err, result)
        if err == nil and result == nil then
            print('Nothing to rename')
            return
        end
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
                confirm(params)
            end,
            buffer = true,
        })
        vim.cmd('startinsert')
    end

    request('textDocument/prepareRename', params, prepare_rename)
end

return M
