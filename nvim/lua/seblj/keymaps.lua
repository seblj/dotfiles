---------- MAPPINGS ----------

local utils = require('seblj.utils')
local resize = require('seblj.utils.resize')
local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command

-- Leader is space and localleader is \
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

---------- GENERAL MAPPINGS ----------

keymap({ 'n', 'v', 'i' }, '√', '<A-j>', { remap = true, desc = 'Fix <A-j> mapping on mac' })
keymap({ 'n', 'v', 'i' }, 'ª', '<A-k>', { remap = true, desc = 'Fix <A-k> mapping on mac' })

keymap({ 'n', 'v', 'i' }, '∆', '<A-j>', { remap = true, desc = 'Fix <A-j> mapping on mac' })
keymap({ 'n', 'v', 'i' }, '˚', '<A-k>', { remap = true, desc = 'Fix <A-k> mapping on mac' })

keymap('n', '<leader>r', utils.reload_config, { desc = 'Reload config' })
keymap('n', '<Tab>', 'gt', { desc = 'Next tab' })
keymap('n', '<S-TAB>', 'gT', { desc = 'Previous tab' })
keymap('n', '<leader>=', '<C-w>=', { desc = 'Resize all splits' })
keymap('n', '<leader>i', 'gg=G', { desc = 'Indent file' })
keymap('n', '<CR>', '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', { expr = true, desc = 'Remove highlights' })
keymap('n', 'gb', '<C-t>', { desc = 'Go back in tag-stack' })
keymap('n', 'gp', '`[v`]', { desc = 'Reselect pasted text' })
keymap('n', '<C-t>', ':tabedit<CR>', { desc = 'Create new tab' })

keymap('n', '<C-h>', '<C-w>h', { desc = 'Navigate to left split' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Navigate to bottom split' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Navigate to top split' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Navigate to right split' })

keymap('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Navigate to left split' })
keymap('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Navigate to bottom split' })
keymap('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Navigate to top split' })
keymap('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Navigate to right split' })
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Escape from term-mode' })

keymap('n', '<S-Right>', resize.resize_right, { desc = 'Resize split right' })
keymap('n', '<S-Left>', resize.resize_left, { desc = 'Resize split left' })
keymap('n', '<S-Up>', resize.resize_up, { desc = 'Resize split up' })
keymap('n', '<S-Down>', resize.resize_down, { desc = 'Resize split down' })

keymap('v', '<', '<gv', { desc = 'Keep visual mode on dedent' })
keymap('v', '>', '>gv', { desc = 'Keep visual mode on indent' })

keymap('n', '<A-j>', ':m.+1<CR>==', { desc = 'Move current line down' })
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move current line down' })
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move current line down' })

keymap('n', '<A-k>', ':m.-2<CR>==', { desc = 'Move current line up' })
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move current line up' })
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move current line up' })

keymap('n', '<leader>j', 'J', { desc = 'Join [count] lines' })

-- Thanks to TJ
-- stylua: ignore start
keymap('n', 'j', function() utils.jump('j') end, { desc = 'gj' })
keymap('n', 'k', function() utils.jump('k') end, { desc = 'gk' })
-- stylua: ignore end

keymap({ 'n', 'v' }, 'J', '10gj')
keymap({ 'n', 'v' }, 'K', '10gk')

keymap({ 'n', 'v', 'o' }, 'H', '^', { desc = 'Move to beginning of line' })
keymap({ 'n', 'v', 'o' }, 'L', '$', { desc = 'Move to end of line' })

keymap('n', '<leader>x', utils.save_and_exec, { desc = 'Save and execute file' })
keymap('x', '@', ':<C-u>:lua require("seblj.utils").visual_macro()<CR>', { desc = 'Macro over visual range' })

-- stylua: ignore start
keymap('n', '<Down>', function() utils.quickfix('down') end, { desc = 'Move down in qflist' })
keymap('n', '<Up>', function() utils.quickfix('up') end, { desc = 'Move up in qflist' })
keymap('n', '<leader>z', '<cmd>TSHighlightCapturesUnderCursor<CR>', { desc = 'Print syntax under cursor' })
-- stylua: ignore end

keymap('n', '<leader>@', function()
    local dir = vim.fn.expand('%:p:h')
    vim.cmd('lcd ' .. dir)
    vim.api.nvim_echo({ { 'cd ' .. dir } }, false, {})
end, {
    desc = 'cd to directory of open buffer',
})

keymap('n', '<leader>tm', function()
    if vim.o.mouse == 'a' then
        vim.opt.mouse = ''
        vim.opt.signcolumn = 'no'
        vim.opt.number = false
        vim.opt.relativenumber = false
    else
        vim.opt.mouse = 'a'
        vim.opt.signcolumn = 'auto'
        vim.opt.number = true
        vim.opt.relativenumber = true
    end
end, {
    desc = 'Toggle mouse, number and signcolumn',
})

---------- ABBREVIATIONS ----------

vim.cmd('cnoreabbrev !! <C-r>:') -- Repeat last command
vim.cmd('cnoreabbrev Q q') -- Quit with Q
vim.cmd('cnoreabbrev W w') -- Write with W
vim.cmd('cnoreabbrev WQ wq') -- Write and quit with WQ
vim.cmd('cnoreabbrev Wq wq') -- Write and quit with Wq
vim.cmd('cnoreabbrev Wqa wqa') -- Write and quit all with Wqa
vim.cmd('cnoreabbrev WQa wqa') -- Write and quit all with WQa
vim.cmd('cnoreabbrev WQA wqa') -- Write and quit all with WQA
vim.cmd('cnoreabbrev Wa wa') -- Write all with Wa
vim.cmd('cnoreabbrev WA wa') -- Write all with WA
vim.cmd('cnoreabbrev Qa qa') -- Quit all with Qa
vim.cmd('cnoreabbrev QA qa') -- Quit all with QA
vim.cmd('cnoreabbrev E e') -- Edit file with E
vim.cmd('cnoreabbrev TERM term')
vim.cmd('cnoreabbrev TERm term')
vim.cmd('cnoreabbrev TErm term')
vim.cmd('cnoreabbrev Term term')

-- Open term in splits
command('T', 'split | term <args>', { nargs = '*', bang = true })
command('VT', 'vsplit | term <args>', { nargs = '*', bang = true })
command('TT', 'tabedit | term <args>', { nargs = '*', bang = true })
