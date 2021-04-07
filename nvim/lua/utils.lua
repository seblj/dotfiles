---------- UTILS ----------

local eval, cmd = vim.api.nvim_eval, vim.cmd

M = {}

-- Set mappings
function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set options
function M.opt(scope, key, value)
    local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-- Used for turning plugins on and off with 'cond'
M.enable = function() return true end
M.disable = function() return false end

-- Telescope function for quick edit of dotfiles
function M.edit_dotfiles()
    require('telescope.builtin').find_files{
        cwd = "~/dotfiles",
        prompt_title = "Dotfiles",
    }
end

-- Ugly oneliner. Find name of tail directory
function M.get_path_tail(dir)
    return string.reverse((dir:reverse()):sub(0, (dir:reverse()):find('/')-1))
end

-- Searches from current dir if not git repo
-- Searches from root of git dir if git repo.
-- Set prompt-title to directory searching from
function M.find_files()
    local git_root = eval("system('git rev-parse --show-toplevel 2> /dev/null')[:-2]")
    local curr_dir = eval("expand('%:p:h:t')")
    if git_root == '' or git_root == nil then
        require("telescope.builtin").find_files {
            prompt_title = curr_dir
        }
    else
        local dir = M.get_path_tail(git_root)
        require("telescope.builtin").find_files {
            cwd = git_root,
            prompt_title = dir
        }
    end
end

function M.live_grep()
    local git_root = eval("system('git rev-parse --show-toplevel 2> /dev/null')[:-2]")
    local curr_dir = eval("expand('%:p:h:t')")
    if git_root == '' or git_root == nil then
        require("telescope.builtin").live_grep {
            prompt_title = curr_dir
        }
    else
        local dir = M.get_path_tail(git_root);
        require("telescope.builtin").live_grep {
            cwd = git_root,
            prompt_title = dir
        }
    end
end

-- Search in current dir. Expand builtin with prompt_title
function M.find_cwd_files()
    local cwd = eval("expand('%:p:h:t')")
    require("telescope.builtin").find_files {
        prompt_title = cwd
    }
end


-- Function to execute macro over a visual range
function M.visual_macro()
    cmd('echo "@".getcmdline()')
    cmd([[execute ":'<,'>normal @".nr2char(getchar())]])
end

-- Find syntax on current line.
-- Should work both with and without tree-sitter.
-- Dependant on tree-sitter setting syntax to empty
function M.syn_stack()
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

-- Reloads config for nvim so I don't need to reopen buffer
function M.reload_config()
    cmd('luafile ~/dotfiles/nvim/init.lua')
    package.loaded['options'] = nil
    package.loaded['keymaps'] = nil
    package.loaded['utils'] = nil
    require('options')
    require('keymaps')
    require('utils')
    for pack, _ in pairs(package.loaded) do
        if string.match(pack, "^config") then
            package.loaded[pack] = nil
            require(pack)
        end
    end
end

-- Use arrowkeys for cnext and cprev only in quickfixlist
function M.quickfix(key)
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

return M
