---------- UTILS ----------

local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.packer_bootstrap = function()
    local is_bootstrap = false
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.loop.fs_stat(install_path).type ~= 'directory' then
        is_bootstrap = true
        vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
        vim.cmd.packadd('packer.nvim')
    end
    return is_bootstrap
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

M.run_term = function(command, ...)
    vim.cmd.term()
    local run_command = vim.b.run ~= nil and vim.b.run .. '\n' or string.format(command .. '\n', ...)
    vim.api.nvim_chan_send(vim.b.terminal_job_id, run_command)

    keymap('n', 'q', '<cmd>q<CR>', { buffer = true })
    vim.cmd.stopinsert()
end

local run_term_split = function(...)
    local current_win = vim.api.nvim_get_current_win()
    local terminal_exists = false
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.w[winid].terminal_execute then
            vim.api.nvim_set_current_win(winid)
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

local runner = {
    python = 'python3 $file',
    c = 'gcc $file -o $output && ./$output; rm $output',
    javascript = 'node $file',
    typescript = 'ts-node $file',
    rust = function()
        local command = 'rustc $file && ./$output; rm $output'
        local match = vim.fn.system('cargo verify-project'):match('{"success":"true"}')
        return match and 'cargo run' or command
    end,
    go = function()
        local command = 'go run $file'
        local dir = vim.fs.dirname(vim.fs.find('go.mod', { upward = true })[1])
        return dir and 'go run ' .. dir or command
    end,
}

-- Save and execute file based on filetype
M.save_and_exec = function()
    vim.api.nvim_echo({ { 'Executing file\n' } }, false, {})
    local ft = vim.bo.filetype
    local file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(file, ':p:h')
    local output = vim.fn.fnamemodify(file, ':t:r')
    vim.cmd.write({ mods = { emsg_silent = true } })
    if ft == 'vim' or ft == 'lua' then
        vim.cmd.source('%')
    elseif ft == 'http' then
        -- Not really save and exec, but think it fits nicely in here for mapping
        require('rest-nvim').run()
    else
        vim.cmd.lcd(dir)
        local command = runner[ft]
        if not command then
            vim.api.nvim_echo({ { string.format('No config found for %s', ft) } }, false, {})
            return
        end
        if type(command) == 'function' then
            command = command()
        end

        command = command:gsub('$file', file)
        command = command:gsub('$output', output)
        command = command:gsub('$dir', dir)
        run_term_split(command)
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
        desc = 'Hide cursor',
    })
    autocmd({ 'BufLeave', 'WinLeave', 'CmdwinEnter', 'CmdlineEnter' }, {
        group = group,
        pattern = '<buffer>',
        callback = function()
            vim.opt.guicursor = vim.opt.guicursor + 'a:Cursor/lCursor'
            vim.opt.guicursor = guicursor_saved
            vim.opt_local.cursorline = false
        end,
        desc = 'Show cursor',
    })
end

----------------------------------------

return M
