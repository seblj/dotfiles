local M = {}
local ui = require('seblj.utils.ui')

local get_git_root = function()
    if vim.fn.has('win32') == 1 then
        return vim.fn.system('git rev-parse --show-toplevel 2> $null'):gsub('%s+', '')
    end
    return vim.fn.system('git rev-parse --show-toplevel 2> /dev/null'):gsub('%s+', '')
end

-- Telescope function for quick edit of dotfiles
M.edit_dotfiles = function()
    require('telescope.builtin').find_files({
        cwd = '~/dotfiles',
        prompt_title = 'Dotfiles',
        hidden = true,
        file_ignore_patterns = { '.git/' },
    })
end

M.installed_plugins = function()
    require('telescope.builtin').find_files({
        cwd = '~/.local/share/nvim/site/pack/packer/',
        follow = true,
        prompt_title = 'Plugins',
    })
end

-- Searches from current dir if not git repo
-- Searches from root of git dir if git repo.
-- Set prompt-title to directory searching from
M.find_files = function()
    local curr_dir = vim.api.nvim_exec('pwd', true)
    local dir = vim.fn.fnamemodify(curr_dir, ':t')
    require('telescope.builtin').find_files({
        prompt_title = dir,
        find_command = { 'rg', '--no-ignore', '--files' },
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

-- Live grep from root of git repo, if it is a repo
-- Else grep current directory
M.live_grep = function()
    local git_root = get_git_root()
    local curr_dir = vim.fn.expand('%:p:h:t')
    if git_root == '' or git_root == nil then
        require('telescope.builtin').live_grep({
            prompt_title = curr_dir,
        })
    else
        local dir = vim.fn.fnamemodify(git_root, ':t')
        require('telescope.builtin').live_grep({
            cwd = git_root,
            prompt_title = dir,
        })
    end
end

-- Grep string with using ui
M.grep_confirm = function()
    local new_name = vim.trim(vim.fn.getline('.'):sub(#'> ' + 1, -1))
    vim.api.nvim_win_close(0, true)
    require('telescope.builtin').grep_string({
        search = new_name,
    })
end

M.grep_string = function()
    local lines = {}
    local title = 'Grep String'
    lines = { title, string.rep(ui.border_line, 30), unpack(lines) }
    local popup_bufnr, _ = ui.popup_create({
        lines = lines,
        width = 30,
        height = 3,
        enter = true,
        prompt = {
            enable = true,
            prefix = '> ',
            -- Highlight doesn't work with title title and border line.
            -- Probably an upstream error as there are other weird behaviours with prompt
            highlight = 'LspRenamePrompt',
        },
    })
    vim.api.nvim_buf_set_option(popup_bufnr, 'modifiable', true)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #title)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)
    vim.api.nvim_buf_set_keymap(
        popup_bufnr,
        'i',
        '<CR>',
        '<cmd>lua require("config.telescope.utils").grep_confirm()<CR>',
        { silent = true }
    )
    vim.api.nvim_command('autocmd CursorMoved <buffer> lua require("seblj.utils.ui").set_cursor()')
    vim.cmd('startinsert')
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

return M
