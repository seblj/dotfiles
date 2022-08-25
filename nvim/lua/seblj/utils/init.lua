---------- UTILS ----------

local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.packer_bootstrap = function()
    local packer_bootstrap = nil
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        packer_bootstrap = vim.fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path,
        })
        vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
    end
    return packer_bootstrap
end

-- Reloads config for nvim so I don't need to reopen buffer in some cases
M.reload_config = function()
    vim.cmd.source('~/dotfiles/nvim/init.lua')
    for pack, _ in pairs(package.loaded) do
        if pack:match('^config') or pack:match('^seblj') then
            package.loaded[pack] = nil
            require(pack)
        end
    end
    vim.api.nvim_echo({ { 'Reloaded config' } }, false, {}) -- Don't add to message history
end

-- Use arrowkeys for cnext and cprev only in quickfixlist
M.quickfix = function(key)
    if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix')) == 1 then
        if key == 'down' then
            vim.cmd.normal('j')
        elseif key == 'up' then
            vim.cmd.normal('k')
        end
    else
        if key == 'down' then
            vim.cmd.cnext({ mods = { emsg_silent = true } })
        elseif key == 'up' then
            vim.cmd.cprev({ mods = { emsg_silent = true } })
        end
    end
end

M.run_term = function(command, ...)
    local terminal_id
    if vim.b.run ~= nil then
        local run = vim.b.run
        vim.cmd.term()
        terminal_id = vim.b.terminal_job_id
        vim.api.nvim_chan_send(terminal_id, run .. '\n')
    else
        vim.cmd.term()
        terminal_id = vim.b.terminal_job_id
        vim.api.nvim_chan_send(terminal_id, string.format(command .. '\n', ...))
    end

    keymap('n', 'q', '<cmd>q<CR>', { buffer = true })
    vim.cmd.stopinsert()
end

local run_term_split = function(...)
    local current_win = vim.api.nvim_get_current_win()
    local terminal_exists = false
    local wininfo = vim.fn.getwininfo()
    for _, win in ipairs(wininfo) do
        if win.variables.terminal_execute then
            vim.cmd.wincmd({ 'w', count = win.winnr })
            terminal_exists = true
        end
    end
    if not terminal_exists then
        vim.cmd.sp()
    end
    vim.w.terminal_execute = true
    M.run_term(...)
    vim.api.nvim_set_current_win(current_win)
end

-- Save and execute file based on filetype
M.save_and_exec = function()
    vim.api.nvim_echo({ { 'Executing file\n' } }, false, {})
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local dir = vim.fn.expand('%:p:h')
    local file = vim.fn.expand('%')
    local output = vim.fn.expand('%:t:r')
    vim.cmd.write({ mods = { emsg_silent = true } })
    if ft == 'vim' or ft == 'lua' then
        vim.cmd.source('%')
    elseif ft == 'python' then
        run_term_split('python3 %s', file)
    elseif ft == 'c' then
        local command = 'gcc %s -o %s && ./%s; rm %s'
        run_term_split(command, file, output, output, output)
    elseif ft == 'rust' then
        vim.cmd.lcd(dir)
        local command = 'rustc %s && ./%s; rm %s'
        if vim.fn.system('cargo verify-project'):match('{"success":"true"}') then
            command = 'cargo run'
        end
        run_term_split(command, file, output, output, output)
    elseif ft == 'go' then
        vim.cmd.lcd(dir)
        run_term_split('go run .')
    elseif ft == 'javascript' then
        run_term_split('node %s', file)
    elseif ft == 'typescript' then
        run_term_split('ts-node %s', file)
    elseif ft == 'http' then
        -- Not really save and exec, but think it fits nicely in here for mapping
        require('rest-nvim').run()
    end
end

M.difference = function(a, b)
    local aa = {}
    for _, v in pairs(a) do
        aa[v] = true
    end
    for _, v in pairs(b) do
        aa[v] = nil
    end
    local ret = {}
    local n = 0
    for _, v in pairs(a) do
        if aa[v] then
            n = n + 1
            ret[n] = v
        end
    end
    return ret
end

M.union = function(a, b)
    local list = {}
    list = a
    for _, v in pairs(b) do
        if not vim.tbl_contains(list, v) then
            table.insert(list, v)
        end
    end
    return list
end

function M.get_syntax_hl()
    if vim.fn.exists('*synstack') == 0 then
        return
    end
    local syntax = {}
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    for _, id in ipairs(vim.fn.synstack(line, col + 1)) do
        table.insert(syntax, vim.fn.synIDattr(id, 'name'))
    end
    P(syntax)
end

---------- HIDE CURSOR ----------

-- https://github.com/tamago324/lir.nvim/blob/master/lua/lir/smart_cursor/init.lua

local guicursor_saved = vim.opt.guicursor

local hide_cursor = function()
    vim.opt.guicursor = vim.opt.guicursor + 'a:CursorTransparent/lCursor'
end

M.setup_hidden_cursor = function()
    hide_cursor()
    vim.opt_local.cursorline = true
    vim.opt_local.winhighlight = 'CursorLine:CursorLineHiddenCursor'
    local group = augroup('HiddenCursor', {})
    autocmd({ 'BufEnter', 'WinEnter', 'CmdwinLeave', 'CmdlineLeave' }, {
        group = group,
        pattern = '<buffer>',
        callback = function()
            hide_cursor()
            vim.opt_local.cursorline = true
            vim.opt_local.winhighlight = 'CursorLine:CursorLineHiddenCursor'
        end,
    })
    autocmd({ 'BufLeave', 'WinLeave', 'CmdwinEnter', 'CmdlineEnter' }, {
        group = group,
        pattern = '<buffer>',
        callback = function()
            vim.opt.guicursor = vim.opt.guicursor + 'a:Cursor/lCursor'
            vim.opt.guicursor = guicursor_saved
            vim.opt_local.cursorline = false
        end,
    })
end

----------------------------------------

return M
