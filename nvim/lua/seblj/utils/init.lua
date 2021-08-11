---------- UTILS ----------

local eval = vim.api.nvim_eval
local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap

local M = {}

-- Thanks to @akinsho for this brilliant function white waiting for builtin autocmd in lua
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/globals.lua
M.augroup = function(name, commands)
    if #commands == 0 then
        M.autocmd(commands)
        return
    end

    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd!')
    for _, c in ipairs(commands) do
        M.autocmd(c)
    end
    vim.cmd('augroup END')
end

M.autocmd = function(c)
    local command = c.command
    if type(command) == 'function' then
        table.insert(seblj._store, command)
        local fn_id = #seblj._store
        command = string.format('lua seblj._store[%s](args)', fn_id)
    end
    local event = c.event
    if type(c.event) == 'table' then
        event = table.concat(c.event, ',')
    end

    local pattern = c.pattern or ''
    if type(c.pattern) == 'table' then
        pattern = table.concat(c.pattern, ',')
    end

    local once = ''
    if c.once == true then
        once = '++once '
    end
    local nested = ''
    if c.nested == true then
        nested = '++nested '
    end

    vim.cmd(string.format('autocmd %s %s %s %s %s', event, pattern, once, nested, command))
end

-- Function to execute macro over a visual range
M.visual_macro = function()
    vim.cmd('echo "@".getcmdline()')
    vim.cmd([[execute ":'<,'>normal @".nr2char(getchar())]])
end

-- All credit to @tjdevries for this
-- https://github.com/tjdevries/config_manager/blob/b9490fe7eb47e2bf21e828474787d8b8e8ed5314/xdg_config/nvim/autoload/tj.vim#L161
M.jump = function(letter)
    local count = eval('v:count')
    if count == 0 then
        vim.cmd(string.format([[call execute('normal! g%s')]], letter))
        return
    end

    if count > 10 then
        vim.cmd([[call execute("normal! m'")]])
    end

    vim.cmd(string.format([[call execute('normal! %s%s', )]], count, letter))
end

-- Reloads config for nvim so I don't need to reopen buffer in some cases
M.reload_config = function()
    vim.cmd('luafile ~/dotfiles/nvim/init.lua')
    for pack, _ in pairs(package.loaded) do
        if pack:match('^config') or pack:match('^seblj') then
            package.loaded[pack] = nil
            require(pack)
        end
    end
    vim.api.nvim_echo({ { 'Reloaded config' } }, false, {}) -- Don't add to message history
end

local switch_commentstring = function(commentstrings)
    local current = vim.api.nvim_buf_get_option(0, 'commentstring')
    for _, cs in pairs(commentstrings) do
        if not current:find(cs, 1, true) then
            return cs
        end
    end
end

M.toggle_commenstring = function()
    local commentstrings = {
        c = { '//%s', '/*%s*/' },
    }
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if not commentstrings[ft] then
        return
    end
    local commentstring = switch_commentstring(commentstrings[ft])
    vim.api.nvim_buf_set_option(0, 'commentstring', commentstring)
    vim.api.nvim_echo({ { string.format('Now using %s', commentstring) } }, false, {})
end

-- Use arrowkeys for cnext and cprev only in quickfixlist
M.quickfix = function(key)
    if eval("empty(filter(getwininfo(), 'v:val.quickfix'))") == 1 then
        if key == 'down' then
            vim.cmd('normal j')
        elseif key == 'up' then
            vim.cmd('normal k')
        end
    else
        if key == 'down' then
            vim.cmd('silent! cnext')
        elseif key == 'up' then
            vim.cmd('silent! cprev')
        end
    end
end

local run_term = function(command, ...)
    vim.cmd('term')
    local terminal_id = eval('b:terminal_job_id')
    vim.api.nvim_chan_send(terminal_id, string.format(command .. '\n', ...))

    nnoremap({ 'q', '<cmd>q<CR>', buffer = true })
    vim.cmd('stopinsert')
end

-- Save and execute file based on filetype
M.save_and_exec = function()
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if ft == 'vim' or ft == 'lua' then
        vim.cmd('silent! write')
        vim.cmd('source %')
    elseif ft == 'python' then
        vim.cmd('silent! write')
        vim.cmd('sp')
        run_term('python3 %s', vim.fn.expand('%'))
    elseif ft == 'c' then
        vim.cmd('silent! write')
        vim.cmd('sp')
        local file = vim.fn.expand('%')
        local output = vim.fn.expand('%:t:r')
        local command = 'gcc %s -o %s && ./%s; rm %s'
        run_term(command, file, output, output, output)
    elseif ft == 'http' then
        -- Not really save and exec, but think it fits nicely in here for mapping
        require('rest-nvim').run()
    end
end

-- Functions for highlighting

M.highlight = function(name, opts)
    if not opts.guisp then
        opts.guisp = 'NONE'
    end
    if not opts.gui then
        opts.gui = 'NONE'
    end
    if name and vim.tbl_count(opts) > 0 then
        if opts.link and opts.link ~= '' then
            vim.cmd('highlight!' .. ' link ' .. name .. ' ' .. opts.link)
        else
            local command = { 'highlight!', name }
            for k, v in pairs(opts) do
                table.insert(command, string.format('%s=', k) .. v)
            end
            vim.cmd(table.concat(command, ' '))
        end
    end
end

M.highlight_all = function(hls)
    for _, hl in ipairs(hls) do
        M.highlight(unpack(hl))
    end
end

---------- HIDE CURSOR ----------

-- https://github.com/tamago324/lir.nvim/blob/master/lua/lir/smart_cursor/init.lua

local guicursor_saved = vim.opt.guicursor

M.hide_cursor = function()
    vim.opt.guicursor = vim.opt.guicursor + 'a:TransparentCursor/lCursor'
end

M.restore_cursor = function()
    vim.opt.guicursor = vim.opt.guicursor + 'a:Cursor/lCursor'
    vim.opt.guicursor = guicursor_saved
end

M.setup_hidden_cursor = function()
    M.augroup('HiddenCursor', {
        {
            event = { 'BufEnter', 'WinEnter', 'CmdwinLeave', 'CmdlineLeave' },
            pattern = '<buffer>',
            command = function()
                vim.cmd('setlocal cursorline')
            end,
        },
        {
            event = { 'BufLeave', 'WinLeave', 'CmdwinEnter', 'CmdlineEnter' },
            pattern = '<buffer>',
            command = function()
                vim.cmd('setlocal nocursorline')
            end,
        },
        {
            event = { 'BufEnter', 'WinEnter', 'CmdwinLeave', 'CmdlineLeave' },
            pattern = '<buffer>',
            command = function()
                M.hide_cursor()
            end,
        },
        {
            event = { 'BufLeave', 'WinLeave', 'CmdwinEnter', 'CmdlineEnter' },
            pattern = '<buffer>',
            command = function()
                M.restore_cursor()
            end,
        },
    })
end

----------------------------------------

return M
