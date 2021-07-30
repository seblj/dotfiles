---------- COC CONFIG ----------

local eval = vim.api.nvim_eval
local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap
local nmap = map.nmap
local inoremap = map.inoremap

vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

nnoremap({ 'gd', function() goto_definition() end })
nnoremap({ 'gb', '<C-t>' })
nnoremap({ 'gh', function() show_documentation() end })
nmap({ 'gR', '<Plug>(coc-rename})' })
nmap({ 'gr', '<cmd>Telescope coc references<CR>' })
nmap({ 'gn', '<Plug>(coc-diagnostic-next)' })
nmap({ 'gp', '<Plug>(coc-diagnostic-prev)' })
nnoremap({ '<leader>ca', ':CocAction<CR>' })
nmap({ '<leader>cd', '<Plug>(coc-diagnostic-info)' })
inoremap({ '<c-space>', 'coc#refresh()', expr = true })

-- Autoimport packages
vim.cmd(
    [[inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]]
)

local M = {}
-- Show documentation under cursor
local show_documentation = function()
    if eval("index(['vim','help'], &filetype)") >= 0 then
        vim.cmd([[execute 'h '.expand('<cword>')]])
    else
        vim.fn.CocAction('doHover')
    end
end

-- Use tagstack for go to definition
local goto_definition = function()
    local from = { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
    local items = { { tagname = vim.fn.expand('<cword>'), from = from } }

    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
    vim.cmd('Telescope coc definitions')
end

return M
