---------- UTILS ----------

local eval, cmd, fn = vim.api.nvim_eval, vim.cmd, vim.fn

local M = {}

-- Set mappings
M.map = function(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

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

    local modifier = c.modifier or ''
    if type(c.modifier) == 'table' then
        modifier = table.concat(c.modifier, ' ')
    end

    local once = ''
    if c.once == true then
        once = '++once '
    end
    local nested = ''
    if c.nested == true then
        nested = '++nested '
    end

    vim.cmd(string.format(
        'autocmd %s %s %s %s %s %s',
        event,
        pattern,
        modifier,
        once,
        nested,
        command
    ))
end

-- cd to directory of current buffer
M.cd = function()
    local dir = fn.expand('%:p:h')
    cmd('cd ' .. dir)
    vim.api.nvim_echo({ { 'cd ' .. dir } }, false, {})
end

-- Function to execute macro over a visual range
M.visual_macro = function()
    cmd('echo "@".getcmdline()')
    cmd([[execute ":'<,'>normal @".nr2char(getchar())]])
end

-- Find syntax on current line.
-- Should work both with and without tree-sitter.
-- Dependant on tree-sitter setting syntax to empty
M.syn_stack = function()
    if eval('&syntax') == '' then
        if eval("exists(':TSHighlightCapturesUnderCursor')") == 2 then
            cmd([[TSHighlightCapturesUnderCursor]])
        end
    else
        if eval("!exists('*synstack')") == 1 then
            return
        end
        cmd([[echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')]])
    end
end

-- Reloads config for nvim so I don't need to reopen buffer in some cases
M.reload_config = function()
    cmd('luafile ~/dotfiles/nvim/init.lua')
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
            cmd('normal j')
        elseif key == 'up' then
            cmd('normal k')
        end
    else
        if key == 'down' then
            cmd('silent! cnext')
        elseif key == 'up' then
            cmd('silent! cprev')
        end
    end
end

-- Save and execute file based on filetype
M.save_and_exec = function()
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if ft == 'vim' then
        cmd('silent! write')
        cmd('source %')
    elseif ft == 'lua' then
        cmd('silent! write')
        cmd('luafile %')
    elseif ft == 'python' then
        cmd('silent! write')
        cmd('sp')
        cmd('term python3 %')
        cmd('startinsert')
        -- Use chansend for C, because it won't tell me if I segfault etc by doing 'term ...'
    elseif ft == 'c' then
        cmd('silent! write')
        cmd('sp')
        local file = eval('expand("%")')
        local output = eval('expand("%:r")')
        cmd('term')
        cmd(
            string.format(
                [[call chansend(%s, ["gcc %s -o %s && ./%s && rm %s\<CR>"]) ]],
                eval('b:terminal_job_id'),
                file,
                output,
                output,
                output
            )
        )
        cmd('nmap <silent> q :q<CR>')
        cmd('stopinsert')
        -- Not really save and exec, but think it fits nicely in here for mapping
    elseif ft == 'http' then
        cmd('lua require("rest-nvim").run()')
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

---------- RESIZE SPLITS ----------

-- https://github.com/ahonn/resize.vim/blob/master/plugin/resize.vim rewritten in lua

local resize_size = 1

local pos_size = '+' .. resize_size
local neg_size = '-' .. resize_size

local get_direction = function(pos)
    local this = fn.winnr()
    cmd(string.format('wincmd %s', pos))
    local next = fn.winnr()
    cmd(string.format('%s wincmd w', this))
    return this == next
end

local is_bottom_window = function()
    local is_top = get_direction('k')
    local is_bottom = get_direction('j')
    return is_bottom and not is_top
end

local is_right_window = function()
    local is_left = get_direction('h')
    local is_right = get_direction('l')
    return is_right and not is_left
end

local resize_vertical = function(size)
    cmd(string.format('vertical resize %s', size))
end

local resize_horizontal = function(size)
    cmd(string.format('resize %s', size))
end

M.resize_up = function()
    if is_bottom_window() then
        return resize_horizontal(pos_size)
    end
    return resize_horizontal(neg_size)
end

M.resize_down = function()
    if is_bottom_window() then
        return resize_horizontal(neg_size)
    end
    return resize_horizontal(pos_size)
end

M.resize_left = function()
    if is_right_window() then
        return resize_vertical(pos_size)
    end
    return resize_vertical(neg_size)
end

M.resize_right = function()
    if is_right_window() then
        return resize_vertical(neg_size)
    end
    return resize_vertical(pos_size)
end

----------------------------------------

---------- HIDE CURSOR ----------

-- https://github.com/tamago324/lir.nvim/blob/master/lua/lir/smart_cursor/init.lua

local guicursor_saved = vim.o.guicursor

M.hide_cursor = function()
    cmd([[set guicursor+=a:TransparentCursor/lCursor]])
end

M.restore_cursor = function()
    cmd([[set guicursor+=a:Cursor/lCursor]])
    vim.o.guicursor = guicursor_saved
end

M.setup_hidden_cursor = function()
    cmd([[autocmd BufEnter,WinEnter,CmdwinLeave,CmdlineLeave <buffer> setlocal cursorline]])
    cmd([[autocmd BufLeave,WinLeave,CmdwinEnter,CmdlineEnter <buffer> setlocal nocursorline]])
    cmd([[autocmd BufEnter,WinEnter,CmdwinLeave,CmdlineLeave <buffer> lua require('seblj.utils').hide_cursor()]])
    cmd([[autocmd BufLeave,WinLeave,CmdwinEnter,CmdlineEnter <buffer> lua require('seblj.utils').restore_cursor()]])
end

----------------------------------------

return M
