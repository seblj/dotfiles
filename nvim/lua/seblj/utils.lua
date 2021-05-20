---------- UTILS ----------

local eval, cmd, fn, exec = vim.api.nvim_eval, vim.cmd, vim.fn, vim.api.nvim_exec

local M = {}

-- Set mappings
M.map = function(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set options
local opts_info = vim.api.nvim_get_all_options_info()
M.opt = setmetatable({}, {
  __newindex = function(_, key, value)
    vim.o[key] = value
    local scope = opts_info[key].scope
    if scope == 'win' then
      vim.wo[key] = value
    elseif scope == 'buf' then
      vim.bo[key] = value
    end
  end
})

-- Telescope function for quick edit of dotfiles
M.edit_dotfiles = function()
    require('telescope.builtin').find_files{
        cwd = "~/dotfiles",
        prompt_title = "Dotfiles",
        hidden = true,
        file_ignore_patterns = { '.git/' }
    }
end

M.installed_plugins = function()
    require('telescope.builtin').find_files{
        cwd = "~/.local/share/nvim/site/pack/packer/",
        follow = true,
        prompt_title = "Plugins",
    }
end

-- Searches from current dir if not git repo
-- Searches from root of git dir if git repo.
-- Set prompt-title to directory searching from
M.find_files = function()
    local curr_dir = exec([[pwd]], true)
    local dir = fn.fnamemodify(curr_dir, ':t')
    require("telescope.builtin").find_files {
        prompt_title = dir,
    }
end

M.git_files = function()
    local git_root = fn.system('git rev-parse --show-toplevel 2> /dev/null'):gsub("%s+", "")
    local dir = fn.fnamemodify(git_root, ':t')
    require("telescope.builtin").git_files {
        prompt_title = dir,
        recurse_submodules = true,
        show_untracked = false
    }
end

-- Live grep from root of git repo, if it is a repo
-- Else grep current directory
M.live_grep = function()
    local git_root = fn.system('git rev-parse --show-toplevel 2> /dev/null'):gsub("%s+", "")
    local curr_dir = fn.expand('%:p:h:t')
    if git_root == '' or git_root == nil then
        require("telescope.builtin").live_grep {
            prompt_title = curr_dir
        }
    else
        local dir = fn.fnamemodify(git_root, ':t')
        require("telescope.builtin").live_grep {
            cwd = git_root,
            prompt_title = dir
        }
    end
end

-- cd to directory of current buffer
M.cd = function()
    local dir = fn.expand('%:p:h')
    cmd('cd ' .. dir)
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
    if (eval('&syntax') == '') then
        if (eval("exists(':TSHighlightCapturesUnderCursor')") == 2) then
            cmd([[TSHighlightCapturesUnderCursor]])
        end
    else
        if (eval("!exists('*synstack')") == 1) then
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
end

-- Use arrowkeys for cnext and cprev only in quickfixlist
M.quickfix = function(key)
    if (eval("empty(filter(getwininfo(), 'v:val.quickfix'))") == 1) then
        if (key == 'down') then
            cmd('normal j')
        elseif (key == 'up') then
            cmd('normal k')
        end
    else
        if (key == 'down') then
            cmd('silent! cnext')
        elseif (key == 'up') then
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
    elseif ft == 'c' then
        cmd('silent! write')
        cmd('sp')
        cmd('term gcc % && ./a.out && rm a.out')
        cmd('startinsert')
    -- Not really save and exec, but think it fits nicely in here for mapping
    elseif ft == 'http' then
        cmd('lua require("rest-nvim").run()')
    end
end


---------- RESIZE SPLITS ----------

-- https://github.com/ahonn/resize.vim/blob/master/plugin/resize.vim rewritten in lua

local resize_size = 1

local pos_size = "+"..resize_size
local neg_size = "-"..resize_size

local get_direction = function(pos)
    local this = fn.winnr()
    cmd(string.format("wincmd %s", pos))
    local next = fn.winnr()
    cmd(string.format("%s wincmd w", this))
    return this == next
end

local is_bottom_window = function()
    local is_top = get_direction("k")
    local is_bottom = get_direction("j")
    return is_bottom and not is_top
end

local is_right_window = function()
    local is_left = get_direction("h")
    local is_right = get_direction("l")
    return is_right and not is_left
end

local resize_vertical = function(size)
    cmd(string.format("vertical resize %s", size))
end

local resize_horizontal = function(size)
    cmd(string.format("resize %s", size))
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
