local M = {}

local use_git_root = true
vim.keymap.set("n", "<leader>tg", function()
    use_git_root = not use_git_root
    local using = use_git_root and "git root" or "current dir"
    vim.api.nvim_echo({ { string.format("Using %s in telescope", using) } }, false, {})
end, {
    desc = "Telescope: Toggle root dir between git and cwd",
})

function M.get_git_root()
    local git_root, ret = require("telescope.utils").get_os_command_output({
        "git",
        "rev-parse",
        "--show-toplevel",
    }, vim.loop.cwd())

    return ret ~= 0 and vim.loop.cwd() or git_root[1]
end

function M.get_root()
    return use_git_root and M.get_git_root() or vim.loop.cwd()
end

-- Telescope function for quick edit of dotfiles
function M.edit_dotfiles()
    require("telescope.builtin").find_files({
        cwd = "~/dotfiles",
        prompt_title = "Dotfiles",
        hidden = true,
        file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/", "fonts/", "icons/" },
    })
end

-- Thanks to TJ: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/custom/multi_rg.lua
function M.multi_grep()
    local root = M.get_root()
    require("telescope.pickers")
        :new({
            debounce = 100,
            prompt_title = vim.fs.basename(root),
            previewer = require("telescope.config").values.grep_previewer({}),
            finder = require("telescope.finders").new_async_job({
                cwd = root,
                entry_maker = require("telescope.make_entry").gen_from_vimgrep({ cwd = root }),
                command_generator = function(prompt)
                    local prompt_split = vim.split(prompt, "  ")
                    local args = { "rg", "-e", prompt_split[1] }
                    if prompt_split[2] then
                        vim.list_extend(args, { "-g", prompt_split[2] })
                    end

                    return vim.tbl_flatten({ args, { "-H", "-n", "-S", "-F", "--column", "-g", "!Spoons/" } })
                end,
            }),
        })
        :find()
end

return M
