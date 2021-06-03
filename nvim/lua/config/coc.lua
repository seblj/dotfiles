---------- COC CONFIG ----------

local utils = require('seblj.utils')
local eval, opt, map, cmd, fn = vim.api.nvim_eval, vim.opt, utils.map, vim.cmd, vim.fn

opt.completeopt = {'menuone', 'noinsert', 'noselect'}

map('n', 'gd', ':lua require("config.coc").goto_definition()<CR>', {noremap = false})
map('n', 'gb', '<C-t>')
map('n', 'gh', ':lua require("config.coc").show_documentation()<CR>')
map('n', 'gR', '<Plug>(coc-rename)', {noremap = false})
map('n', 'gr', '<cmd>Telescope coc references<CR>', {noremap = false})
map('n', 'gn', '<Plug>(coc-diagnostic-next)', {noremap = false})
map('n', 'gp', '<Plug>(coc-diagnostic-prev)', {noremap = false})
map('n', '<leader>ca', ':CocAction<CR>')
map('n', '<leader>cd', '<Plug>(coc-diagnostic-info)', {noremap = false})
map('i', '<c-space>', 'coc#refresh()', {expr = true})

-- Autoimport packages
cmd([[inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]])

local M = {}
-- Show documentation under cursor
M.show_documentation = function()
    if (eval("index(['vim','help'], &filetype)") >= 0) then
        cmd([[execute 'h '.expand('<cword>')]])
    else
        fn.CocAction('doHover')
    end
end

-- Use tagstack for go to definition
M.goto_definition = function()
    local from = {vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0}
    local items = {{tagname = vim.fn.expand('<cword>'), from = from}}

    vim.fn.settagstack(vim.fn.win_getid(), {items=items}, 't')
    cmd('Telescope coc definitions')
end

return M
