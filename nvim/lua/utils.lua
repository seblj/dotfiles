---------- UTILS ----------

M = {}

-- Set mappings
function M.map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Set options
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
function M.opt(scope, key, value)
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

function M.get_path_tail(dir)
    return string.reverse((dir:reverse()):sub(0, (dir:reverse()):find('/')-1))
end

-- Searches from current dir if not git repo
-- Searches from root of git dir if git repo.
-- Set prompt-title to directory searching from
function M.find_files()
    local git_root = vim.api.nvim_eval("system('git rev-parse --show-toplevel 2> /dev/null')[:-2]")
    local curr_dir = vim.api.nvim_eval("expand('%:p:h:t')")
    if git_root == '' or git_root == nil then
        require("telescope.builtin").find_files {
            prompt_title = curr_dir
        }
    else
        -- Ugly oneliner. Find name of directory for prompt_title
        local dir = M.get_path_tail(git_root)
        require("telescope.builtin").find_files {
            cwd = git_root,
            prompt_title = dir
        }
    end
end

function M.live_grep()
    local git_root = vim.api.nvim_eval("system('git rev-parse --show-toplevel 2> /dev/null')[:-2]")
    local curr_dir = vim.api.nvim_eval("expand('%:p:h:t')")
    if git_root == '' or git_root == nil then
        require("telescope.builtin").live_grep {
            prompt_title = curr_dir
        }
    else
        -- Ugly oneliner. Find name of directory for prompt_title
        local dir = M.get_path_tail(git_root);
        require("telescope.builtin").live_grep {
            cwd = git_root,
            prompt_title = dir
        }
    end
end

function M.find_cwd_files()
    local cwd = vim.api.nvim_eval("expand('%:p:h:t')")
    require("telescope.builtin").find_files {
        prompt_title = cwd
    }
end

return M
