local M = {}
local telescope_utils = require('telescope.utils')
local keymap = vim.keymap.set
local Job = require('plenary.job')

local use_git_root = true
keymap('n', '<leader>tg', function()
    use_git_root = not use_git_root
    if use_git_root then
        vim.api.nvim_echo({ { 'Using git root in telescope' } }, false, {})
    else
        vim.api.nvim_echo({ { 'Using current dir in telescope' } }, false, {})
    end
end, {
    desc = 'Telescope: Toggle root dir between git and cwd',
})

local get_git_root = function()
    local git_root, ret =
        telescope_utils.get_os_command_output({ 'git', 'rev-parse', '--show-toplevel' }, vim.loop.cwd())

    return ret ~= 0 and vim.loop.cwd() or git_root[1]
end

local get_root = function()
    return use_git_root and get_git_root() or vim.loop.cwd()
end

-- Telescope function for quick edit of dotfiles
M.edit_dotfiles = function()
    require('telescope.builtin').find_files({
        cwd = '~/dotfiles',
        prompt_title = 'Dotfiles',
        hidden = true,
        file_ignore_patterns = { '%.git/', 'hammerspoon/Spoons/', 'fonts/', 'icons/' },
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
    local curr_dir = vim.fn.fnamemodify(vim.loop.cwd(), ':t')
    require('telescope.builtin').find_files({
        prompt_title = curr_dir,
    })
end

M.git_files = function()
    local dir = vim.fn.fnamemodify(get_git_root(), ':t')
    require('telescope.builtin').git_files({
        prompt_title = dir,
        recurse_submodules = true,
        show_untracked = false,
    })
end

-- Thanks to TJ: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/custom/multi_rg.lua
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')

M.multi_grep = function(opts)
    opts = opts or {}
    local root = get_root()
    local dir = vim.fn.fnamemodify(root, ':t')

    local custom_grep = finders.new_async_job({
        command_generator = function(prompt)
            if not prompt or prompt == '' then
                return nil
            end

            local prompt_split = vim.split(prompt, '  ')

            local args = { 'rg' }
            if prompt_split[1] then
                table.insert(args, '-e')
                table.insert(args, prompt_split[1])
            end

            if prompt_split[2] then
                table.insert(args, '-g')
                table.insert(args, prompt_split[2])
            end

            return vim.tbl_flatten({
                args,
                {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    '-g',
                    '!Spoons/',
                },
            })
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = root,
    })

    pickers
        .new(opts, {
            debounce = 100,
            prompt_title = dir,
            finder = custom_grep,
            previewer = conf.grep_previewer(opts),
            sorter = require('telescope.sorters').empty(),
        })
        :find()
end

-- Live grep from root of git repo
M.live_grep = function()
    local root = get_root()
    local dir = vim.fn.fnamemodify(root, ':t')
    require('telescope.builtin').live_grep({
        cwd = root,
        prompt_title = dir,
    })
end

M.grep_string = function()
    vim.ui.input({ prompt = 'Grep String: ' }, function(input)
        local root = get_root()
        local dir = vim.fn.fnamemodify(root, ':t')
        vim.schedule(function()
            require('telescope.builtin').grep_string({
                cwd = root,
                search = input,
                prompt_title = dir,
                file_ignore_patterns = { '%.git/', 'hammerspoon/Spoons/' },
            })
        end)
    end)
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
    local bufname = vim.api.nvim_buf_get_name(0)
    local curr_dir = vim.fn.fnamemodify(bufname, ':p:h:t')
    local cwd
    if git_root == '' or git_root == nil then
        cwd = curr_dir
    end

    local path

    Job:new({
        command = 'fd',
        args = { '-t', 'd', '-I', '-d', '2', '-a', 'node_modules' },
        cwd = cwd,
        on_exit = function(j, _)
            path = j:result()[1]
        end,
    }):sync()

    if not path then
        return
    end
    require('telescope.builtin').find_files({
        cwd = path,
        prompt_title = 'Node Modules',
    })
end

return M
