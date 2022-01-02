---------- MAPPINGS ----------

local keymap = vim.keymap.set
local command = vim.api.nvim_add_user_command

-- Leader is space and localleader is \
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

---------- GENERAL MAPPINGS ----------

-- stylua: ignore
keymap('n', '<leader>r', function() require('seblj.utils').reload_config() end) -- Reload config
keymap('n', 'œ', '<Tab>') -- Alt-o for jumplist
keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true }) -- Tab for next completion
keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true }) -- Shift-tab for previous completion
keymap('n', '<Tab>', 'gt') -- Next tab
keymap('n', '<S-TAB>', 'gT') -- Previous tab
keymap('n', '<leader>=', '<C-w>=') -- Resize windows
keymap('n', '<leader>i', 'gg=G') -- Indent file
keymap('n', '<CR>', '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', { expr = true }) -- Remove highlights with enter
keymap('n', 'gp', '`[v`]') -- Reselect pasted text
keymap('n', '<C-f>', 'za') -- Fold
keymap('n', '<C-t>', ':tabedit<CR>')

keymap('n', '<C-h>', '<C-w>h') -- Navigate to left split
keymap('n', '<C-j>', '<C-w>j') -- Navigate to bottom split
keymap('n', '<C-k>', '<C-w>k') -- Navigate to top split
keymap('n', '<C-l>', '<C-w>l') -- Navigate to right split

keymap('t', '<C-h>', '<C-\\><C-N><C-w>h') -- Navigate to left split
keymap('t', '<C-j>', '<C-\\><C-N><C-w>j') -- Navigate to bottom split
keymap('t', '<C-k>', '<C-\\><C-N><C-w>k') -- Navigate to top split
keymap('t', '<C-l>', '<C-\\><C-N><C-w>l') -- Navigate to right split
keymap('t', '<Esc><Esc>', '<C-\\><C-n>') -- Exit term-mode

-- stylua: ignore start
keymap('n', '<S-Right>', function() require('seblj.utils.resize').resize_right() end) -- Resize split right
keymap('n', '<S-Left>', function() require('seblj.utils.resize').resize_left() end) -- Resize split left
keymap('n', '<S-Up>', function() require('seblj.utils.resize').resize_up() end) -- Resize split up
keymap('n', '<S-Down>', function() require('seblj.utils.resize').resize_down() end) -- Resize split down
-- stylua: ignore end

keymap('v', '<', '<gv') -- Keep visual on indent
keymap('v', '>', '>gv') -- Keep visual on indent

-- has('mac') is not enough if using ssh
if vim.fn.has('mac') == 1 or vim.fn.getenv('TERM_PROGRAM') == 'iTerm.app' then
    keymap('n', '√', ':m.+1<CR>==') -- Move line with Alt-j
    keymap('v', '√', ":m '>+1<CR>gv=gv") -- Move line with Alt-j
    keymap('i', '√', '<Esc>:m .+1<CR>==gi') -- Move line with Alt-j

    keymap('n', 'ª', ':m.-2<CR>==') -- Move line with Alt-k
    keymap('v', 'ª', ":m '<-2<CR>gv=gv") -- Move line with Alt-k
    keymap('i', 'ª', '<Esc>:m .-2<CR>==gi') -- Move line with Alt-k
else
    keymap('n', '<A-j>', ':m.+1<CR>==') -- Move line with Alt-j
    keymap('v', '<A-j>', ":m '>+1<CR>gv=gv") -- Move line with Alt-j
    keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi') -- Move line with Alt-j

    keymap('n', '<A-k>', ':m.-2<CR>==') -- Move line with Alt-k
    keymap('v', '<A-k>', ":m '<-2<CR>gv=gv") -- Move line with Alt-k
    keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi') -- Move line with Alt-k
end

keymap('n', '<leader>j', 'J') -- Join lines

-- Thanks to TJ
-- stylua: ignore start
keymap('n', 'j', function() require('seblj.utils').jump('j') end)
keymap('n', 'k', function() require('seblj.utils').jump('k') end)
-- stylua: ignore end

keymap({ 'n', 'v' }, 'J', '10gj') -- 10 lines down with J
keymap({ 'n', 'v' }, 'K', '10gk') -- 10 lines up with K

keymap({ 'n', 'v', 'o' }, 'H', '^') -- Beginning of line
keymap({ 'n', 'v', 'o' }, 'L', '$') -- End of line

-- stylua: ignore
keymap('n', '<leader>x', function() require('seblj.utils').save_and_exec() end) -- Save and execute vim or lua file
keymap('x', '@', ':<C-u>:lua require("seblj.utils").visual_macro()<CR>') -- Macro over visual range

-- stylua: ignore start
keymap('n', '<Down>', function() require('seblj.utils').quickfix('down') end) -- Move down in quickfixlist
keymap('n', '<Up>', function() require('seblj.utils').quickfix('up') end) -- Move up in quickfixlist
keymap('n', '<leader>z', '<cmd>TSHighlightCapturesUnderCursor<CR>') -- Print syntax under cursor
-- stylua: ignore end
keymap('n', '<leader><ESC><leader>', ':cclose<CR> `A') -- Close and go to mark

keymap('n', '<leader>@', function()
    local dir = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. dir)
    vim.api.nvim_echo({ { 'cd ' .. dir } }, false, {})
end) -- cd to directory of open buffer

vim.cmd('cnoreabbrev w!! w suda://%') -- Write with sudo
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

-- Open term in splits
command('T', 'split | term <args>', { nargs = '*', bang = true })
command('VT', 'vsplit | term <args>', { nargs = '*', bang = true })
