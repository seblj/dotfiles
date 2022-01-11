local M = {}
local telescope_utils = require('telescope.utils')
local Job = require('plenary.job')

local get_git_root = function()
    local git_root, ret = telescope_utils.get_os_command_output(
        { 'git', 'rev-parse', '--show-toplevel' },
        vim.loop.cwd()
    )

    if ret ~= 0 then
        return vim.loop.cwd()
    end
    return git_root[1]
end

-- Telescope function for quick edit of dotfiles
M.edit_dotfiles = function()
    require('telescope.builtin').find_files({
        cwd = '~/dotfiles',
        prompt_title = 'Dotfiles',
        hidden = true,
        file_ignore_patterns = { '.git/', 'hammerspoon/Spoons/', 'fonts/', 'icons/' },
    })
end

M.plugins = function()
    require('telescope.builtin').find_files({
        cwd = vim.fn.stdpath('data') .. '/site/pack/packer/',
        follow = true,
        prompt_title = 'Plugins',
    })
end

M.find_files = function()
    local curr_dir = vim.fn.expand('%:p:h:t')
    require('telescope.builtin').find_files({
        prompt_title = curr_dir,
    })
end

M.git_files = function()
    local git_root = get_git_root()
    local dir = vim.fn.fnamemodify(git_root, ':t')
    require('telescope.builtin').git_files({
        prompt_title = dir,
        recurse_submodules = true,
        show_untracked = false,
    })
end

-- Live grep from root of git repo
M.live_grep = function()
    local git_root = get_git_root()
    local dir = vim.fn.fnamemodify(git_root, ':t')
    require('telescope.builtin').live_grep({
        cwd = git_root,
        prompt_title = dir,
    })
end

-- Grep string with using ui
local grep_confirm = function(input)
    local git_root = get_git_root()
    local dir = vim.fn.fnamemodify(git_root, ':t')
    vim.schedule(function()
        require('telescope.builtin').grep_string({
            cwd = git_root,
            search = input,
            prompt_title = dir,
        })
    end)
end

M.grep_string = function()
    vim.ui.input({ prompt = 'Grep String: ' }, grep_confirm)
end

-- Search neovim repo
M.search_neovim = function()
    require('telescope.builtin').find_files({
        cwd = '~/Applications/neovim',
        prompt_title = 'Neovim',
        hidden = true,
        file_ignore_patterns = { '.git/' },
    })
end

-- See if I can find a mapping for this
M.find_node_modules = function()
    local git_root = get_git_root()
    local curr_dir = vim.fn.expand('%:p:h:t')
    local cwd
    if git_root == '' or git_root == nil then
        cwd = curr_dir
    end

    local path

    Job
        :new({
            command = 'fd',
            args = { '-t', 'd', '-I', '-d', '2', '-a', 'node_modules' },
            cwd = cwd,
            on_exit = function(j, _)
                path = j:result()[1]
            end,
        })
        :sync()

    if not path then
        return
    end
    require('telescope.builtin').find_files({
        cwd = path,
        prompt_title = 'Node Modules',
    })
end

return M
