---------- COC CONFIG ----------

local eval = vim.api.nvim_eval
local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap
local inoremap = map.inoremap

vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

nnoremap({ 'gd', require('config.coc').goto_definition(), noremap = false })
nnoremap({ 'gb', '<C-t>' })
nnoremap({ 'gh', require('config.coc').show_documentation })
nnoremap({ 'gR', '<Plug>(coc-rename})', noremap = false })
nnoremap({ 'gr', '<cmd>Telescope coc references<CR>', noremap = false })
nnoremap({ 'gn', '<Plug>(coc-diagnostic-next)', noremap = false })
nnoremap({ 'gp', '<Plug>(coc-diagnostic-prev)', noremap = false })
nnoremap({ '<leader>ca', ':CocAction<CR>' })
nnoremap({ '<leader>cd', '<Plug>(coc-diagnostic-info)', noremap = false })
inoremap({ '<c-space>', 'coc#refresh()', expr = true })

-- Autoimport packages
vim.cmd(
    [[inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]]
)

local M = {}
-- Show documentation under cursor
M.show_documentation = function()
    if eval("index(['vim','help'], &filetype)") >= 0 then
        vim.cmd([[execute 'h '.expand('<cword>')]])
    else
        vim.fn.CocAction('doHover')
    end
end

-- Use tagstack for go to definition
M.goto_definition = function()
    local from = { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
    local items = { { tagname = vim.fn.expand('<cword>'), from = from } }

    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
    vim.cmd('Telescope coc definitions')
end

return M
