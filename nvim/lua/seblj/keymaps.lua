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

keymap('n', '<C-i>', '<C-i>')
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
keymap('n', '<leader>gh', ':help <C-r><C-w><CR>', { desc = 'Search in help for word under cursor' })

keymap('v', '<', '<gv', { desc = 'Keep visual mode on dedent' })
keymap('v', '>', '>gv', { desc = 'Keep visual mode on indent' })

keymap('n', '<A-j>', ':m.+1<CR>==', { desc = 'Move current line down' })
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move current line down' })
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move current line down' })

keymap('n', '<A-k>', ':m.-2<CR>==', { desc = 'Move current line up' })
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move current line up' })
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move current line up' })

keymap('x', '<leader>sr', [["sy:let @/=@s<CR>cgn]], { desc = 'Replace word under cursor' })
keymap('n', '<leader>sr', [[:let @/='\<'.expand('<cword>').'\>'<CR>cgn]], {
    desc = 'Replace word under cursor',
})
keymap('n', '<leader>sa', [[:let @/='\<'.expand('<cword>').'\>'<CR>cgn<C-r>"]], {
    desc = 'Append to word under cursor',
})

keymap('n', '<leader>j', 'J', { desc = 'Join [count] lines' })

keymap('n', 'j', 'v:count ? "j" : "gj"', { expr = true, desc = 'gj' })
keymap('n', 'k', 'v:count ? "k" : "gk"', { expr = true, desc = 'gk' })

keymap({ 'n', 'v' }, 'J', '10gj')
keymap({ 'n', 'v' }, 'K', '10gk')

keymap({ 'n', 'v', 'o' }, 'H', '^', { desc = 'Move to beginning of line' })
keymap({ 'n', 'v', 'o' }, 'L', '$', { desc = 'Move to end of line' })

keymap('n', '<leader>x', utils.save_and_exec, { desc = 'Save and execute file' })

local visual_macro = [[:<C-u>:echo "@".getcmdline()<CR>:execute ":'<,'>normal @".nr2char(getchar())<CR>]]
keymap('x', '@', visual_macro, { desc = 'Macro over visual range' })

keymap('n', '<Down>', function()
    if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix')) == 1 then
        vim.cmd.normal('j')
    else
        vim.cmd.cnext({ mods = { emsg_silent = true } })
    end
end, { desc = 'Move down in qflist' })

keymap('n', '<Up>', function()
    if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix')) == 1 then
        vim.cmd.normal('k')
    else
        vim.cmd.cprev({ mods = { emsg_silent = true } })
    end
end, { desc = 'Move up in qflist' })

keymap('n', '<leader>z', '<cmd>TSHighlightCapturesUnderCursor<CR>', { desc = 'Print syntax under cursor' })

keymap('n', '<leader>@', '<cmd>lcd %:p:h<CR><cmd>pwd<CR>', { desc = 'cd to directory of open buffer' })

keymap('n', '<leader>tm', function()
    if vim.o.mouse == 'nvi' then
        vim.opt.mouse = ''
        vim.opt.signcolumn = 'no'
        vim.opt.number = false
        vim.opt.relativenumber = false
    else
        vim.opt.mouse = 'nvi'
        vim.opt.signcolumn = 'auto'
        vim.opt.number = true
        vim.opt.relativenumber = true
    end
end, {
    desc = 'Toggle mouse, number and signcolumn',
})

vim.keymap.set('n', '<leader>tf', function()
    if vim.b.do_formatting == nil then
        vim.b.do_formatting = false
    else
        vim.b.do_formatting = not vim.b.do_formatting
    end
    if vim.b.do_formatting then
        vim.api.nvim_echo({ { 'Enabled autoformat on save' } }, false, {})
    else
        vim.api.nvim_echo({ { 'Disabled autoformat on save' } }, false, {})
    end
end, { desc = 'Format: Toggle format on save' })

keymap('n', '<leader>ts', function()
    vim.opt.spelllang = vim.o.spelllang == 'en' and 'nb' or 'en'
    print('Setting spelllang to', vim.o.spelllang)
end, { desc = 'Toggle spelllang between english and norwegian' })

keymap('n', '<leader>m', function()
    if vim.t.maximized then
        vim.t.maximized = false
        vim.cmd.tabclose()
    elseif vim.fn.winnr('$') ~= 1 then
        vim.cmd.split({ mods = { tab = 1 } })
        vim.t.maximized = true
    end
end, { desc = 'Maximize current split' })

keymap('n', '<leader>dr', function()
    local file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(file, ':p:h')
    local root_file = vim.fs.find({ 'Sahka.Server.sln', 'ApiGateway.csproj' }, { path = dir, upward = true })[1]
    if root_file then
        local root_dir = vim.fn.fnamemodify(root_file, ':p:h')
        vim.cmd.lcd(root_dir)
        vim.fn.execute('!dotnet restore')
        vim.cmd.LspRestart()
    else
        vim.api.nvim_echo({ { "Couldn't find root of project" } }, false, {})
    end
end)

---------- ABBREVIATIONS ----------

vim.cmd.cnoreabbrev({ '!!', '<C-r>:' }) -- Repeat last command
vim.cmd.cnoreabbrev({ 'Q', 'q' }) -- Quit with Q
vim.cmd.cnoreabbrev({ 'W', 'w' }) -- Write with W
vim.cmd.cnoreabbrev({ 'WQ', 'wq' }) -- Write and quit with WQ
vim.cmd.cnoreabbrev({ 'Wq', 'wq' }) -- Write and quit with Wq
vim.cmd.cnoreabbrev({ 'Wqa', 'wqa' }) -- Write and quit all with Wqa
vim.cmd.cnoreabbrev({ 'WQa', 'wqa' }) -- Write and quit all with WQa
vim.cmd.cnoreabbrev({ 'WQA', 'wqa' }) -- Write and quit all with WQA
vim.cmd.cnoreabbrev({ 'Wa', 'wa' }) -- Write all with Wa
vim.cmd.cnoreabbrev({ 'WA', 'wa' }) -- Write all with WA
vim.cmd.cnoreabbrev({ 'Qa', 'qa' }) -- Quit all with Qa
vim.cmd.cnoreabbrev({ 'QA', 'qa' }) -- Quit all with QA
vim.cmd.cnoreabbrev({ 'E', 'e' }) -- Edit file with E
vim.cmd.cnoreabbrev({ 'TERM', 'term' })
vim.cmd.cnoreabbrev({ 'TERm', 'term' })
vim.cmd.cnoreabbrev({ 'TErm', 'term' })
vim.cmd.cnoreabbrev({ 'Term', 'term' })

-- Open term in splits
local opts = { nargs = '*', bang = true }

local create_command = function(direction, key, focus)
    local completion = function(_, cmdline, _)
        local file = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(file, ':p:h')
        vim.cmd.lcd(dir)
        local run_command = vim.split(cmdline, key .. ' ')[2]
        return utils.get_zsh_completion(run_command)
    end
    opts['complete'] = completion
    command(key, function(x)
        utils.run_term(direction, focus, x.args)
    end, opts)
end
create_command('horizontal', 'T', true)
create_command('vertical', 'VT', true)
create_command('tab', 'TT', true)
