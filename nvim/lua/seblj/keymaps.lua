---------- MAPPINGS ----------

local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap
local inoremap = map.inoremap
local vnoremap = map.vnoremap
local tnoremap = map.tnoremap
local onoremap = map.onoremap
local xnoremap = map.xnoremap

-- Leader is space and localleader is \
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

---------- GENERAL MAPPINGS ----------

nnoremap({ 'œ', '<Tab>' }) -- Alt-o for jumplist
inoremap({ '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', expr = true }) -- Tab for next completion
inoremap({ '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', expr = true }) -- Shift-tab for previous completion
nnoremap({ '<Tab>', 'gt' }) -- Next tab
nnoremap({ '<S-TAB>', 'gT' }) -- Previous tab
nnoremap({
    '<leader>r',
    function()
        require('seblj.utils').reload_config()
    end,
}) -- Reload config
nnoremap({ '<leader>=', '<C-w>=' }) -- Resize windows
nnoremap({ '<leader>i', 'gg=G' }) -- Indent file
nnoremap({ 'ß', ':%s//gI<Left><Left><Left>', silent = false }) -- Search and replace (Alt-s)
vnoremap({ 'ß', ':s//gI<Left><Left><Left>', silent = false }) -- Search and replace (Alt-s)
nnoremap({ '<CR>', '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', expr = true }) -- Remove highlights with enter
nnoremap({ '<C-f>', 'za' }) -- Fold
nnoremap({ '<C-t>', ':tabedit<CR>' }) -- Create new tab

nnoremap({ '<C-h>', '<C-w>h' }) -- Navigate to left split
nnoremap({ '<C-j>', '<C-w>j' }) -- Navigate to bottom split
nnoremap({ '<C-k>', '<C-w>k' }) -- Navigate to top split
nnoremap({ '<C-l>', '<C-w>l' }) -- Navigate to right split

tnoremap({ '<C-h>', '<C-\\><C-N><C-w>h' }) -- Navigate to left split
tnoremap({ '<C-j>', '<C-\\><C-N><C-w>j' }) -- Navigate to bottom split
tnoremap({ '<C-k>', '<C-\\><C-N><C-w>k' }) -- Navigate to top split
tnoremap({ '<C-l>', '<C-\\><C-N><C-w>l' }) -- Navigate to right split
tnoremap({ '<Esc><Esc>', '<C-\\><C-n>' }) -- Exit term-mode

nnoremap({
    '<S-Right>',
    function()
        require('seblj.utils.resize').resize_right()
    end,
}) -- Resize split right
nnoremap({
    '<S-Left>',
    function()
        require('seblj.utils.resize').resize_left()
    end,
}) -- Resize split left
nnoremap({
    '<S-Up>',
    function()
        require('seblj.utils.resize').resize_up()
    end,
}) -- Resize split up
nnoremap({
    '<S-Down>',
    function()
        require('seblj.utils.resize').resize_down()
    end,
}) -- Resize split down

vnoremap({ '<', '<gv' }) -- Keep visual on indent
vnoremap({ '>', '>gv' }) -- Keep visual on indent

if vim.fn.has('mac') == 1 then
    nnoremap({ '√', ':m.+1<CR>==' }) -- Move line with Alt-j
    vnoremap({ '√', ":m '>+1<CR>gv=gv" }) -- Move line with Alt-j
    inoremap({ '√', '<Esc>:m .+1<CR>==gi' }) -- Move line with Alt-j

    nnoremap({ 'ª', ':m.-2<CR>==' }) -- Move line with Alt-k
    vnoremap({ 'ª', ":m '<-2<CR>gv=gv" }) -- Move line with Alt-k
    inoremap({ 'ª', '<Esc>:m .-2<CR>==gi' }) -- Move line with Alt-k
else
    nnoremap({ '<A-j>', ':m.+1<CR>==' }) -- Move line with Alt-j
    vnoremap({ '<A-j>', ":m '>+1<CR>gv=gv" }) -- Move line with Alt-j
    inoremap({ '<A-j>', '<Esc>:m .+1<CR>==gi' }) -- Move line with Alt-j

    nnoremap({ '<A-k>', ':m.-2<CR>==' }) -- Move line with Alt-k
    vnoremap({ '<A-k>', ":m '<-2<CR>gv=gv" }) -- Move line with Alt-k
    inoremap({ '<A-k>', '<Esc>:m .-2<CR>==gi' }) -- Move line with Alt-k
end

nnoremap({
    'gca',
    function()
        require('seblj.utils').toggle_commenstring()
    end,
})
nnoremap({ '<leader>j', 'J' }) -- Join lines

-- Thanks to TJ
nnoremap({
    'j',
    function()
        require('seblj.utils').jump('j')
    end,
})
nnoremap({
    'k',
    function()
        require('seblj.utils').jump('k')
    end,
})

nnoremap({ 'J', '10j' }) -- 10 lines down with J
vnoremap({ 'J', '10j' }) -- 10 lines down with J
nnoremap({ 'K', '10k' }) -- 10 lines up with K
vnoremap({ 'K', '10k' }) -- 10 lines up with K

nnoremap({ 'H', '^' }) -- Beginning of line
nnoremap({ 'L', '$' }) -- End of line
vnoremap({ 'H', '^' }) -- Beginning of line
vnoremap({ 'L', '$' }) -- End of line
onoremap({ 'H', '^' }) -- Beginning of line
onoremap({ 'L', '$' }) -- End of line

nnoremap({
    '<leader>x',
    function()
        require('seblj.utils').save_and_exec()
    end,
}) -- Save and execute vim or lua file
xnoremap({ '@', ':<C-u>:lua require("seblj.utils").visual_macro()<CR>' }) -- Macro over visual range
nnoremap({
    '<leader>z',
    function()
        if vim.api.nvim_eval('&syntax') == '' then
            if vim.api.nvim_eval("exists(':TSHighlightCapturesUnderCursor')") == 2 then
                vim.cmd('TSHighlightCapturesUnderCursor')
            end
        else
            if vim.api.nvim_eval("!exists('*synstack')") == 1 then
                return
            end
            vim.cmd([[echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')]])
        end
    end,
})
nnoremap({
    '<Down>',
    function()
        require('seblj.utils').quickfix('down')
    end,
}) -- Move down in quickfixlist
nnoremap({
    '<Up>',
    function()
        require('seblj.utils').quickfix('up')
    end,
}) -- Move up in quickfixlist
nnoremap({ '<leader><ESC><leader>', ':cclose<CR> `A' }) -- Close and go to mark
nnoremap({
    '<leader>@',
    function()
        local dir = vim.fn.expand('%:p:h')
        vim.cmd('cd ' .. dir)
        vim.api.nvim_echo({ { 'cd ' .. dir } }, false, {})
    end,
}) -- cd to directory of open buffer

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

vim.cmd('command! -nargs=* T split | term <args>') -- Open term in split with T
vim.cmd('command! -nargs=* VT vsplit | term <args>') -- Open term in vsplit with VT
