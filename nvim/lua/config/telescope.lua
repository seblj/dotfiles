---------- TELESCOPE CONFIG ----------

return {
    config = function()
        require("telescope").setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 120,
                    },
                },
                mappings = {
                    i = {
                        ["<C-j>"] = function(prompt_bufnr)
                            require("telescope.actions.layout").cycle_layout_next(prompt_bufnr)
                        end,
                        ["<C-k>"] = function(prompt_bufnr)
                            require("telescope.actions.layout").cycle_layout_prev(prompt_bufnr)
                        end,
                    },
                },
            },
            extensions = {
                fzf = {
                    override_file_sorter = true,
                    override_generic_sorter = true,
                },
                file_browser = {
                    hidden = true,
                },
            },
        })

        require("telescope").load_extension("fzf")
        require("telescope").load_extension("file_browser")
        if pcall(require, "notify") then
            require("telescope").load_extension("notify")
        end
    end,

    init = function()
        local utils = require("seblj.utils")
        local function map(mode, keys, func, desc)
            vim.keymap.set(mode, keys, function()
                require("telescope.builtin")[func]()
            end, { desc = string.format("Telescope: %s", desc) })
        end

        local use_git_root = true
        vim.keymap.set("n", "<leader>tg", function()
            use_git_root = not use_git_root
            local using = use_git_root and "git root" or "current dir"
            vim.api.nvim_echo({ { string.format("Using %s in telescope", using) } }, false, {})
        end, {
            desc = "Telescope: Toggle root dir between git and cwd",
        })

        local function git_root()
            return utils.get_os_command_output(
                "git",
                { args = { "rev-parse", "--show-toplevel" }, cwd = vim.loop.cwd() }
            )[1]
        end

        local function get_root()
            return use_git_root and git_root() or vim.loop.cwd()
        end

        map("n", "<leader>fo", "oldfiles", "Oldfiles")
        map("n", "<leader>fb", "buffers", "Buffers")
        map("n", "<leader>fk", "keymaps", "Keymaps")
        map("n", "<leader>fa", "autocommands", "Autocommands")
        map("n", "<leader>fh", "help_tags", "Helptags")
        map("n", "<leader>fc", "command_history", "Command history")
        map("n", "<leader>vo", "vim_options", "Vim options")

        -- Telescope function for quick edit of dotfiles
        vim.keymap.set("n", "<leader>fd", function()
            require("telescope.builtin").find_files({
                cwd = "~/dotfiles",
                prompt_title = "Dotfiles",
                hidden = true,
                file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/", "fonts/", "icons/" },
            })
        end, { desc = "Telescope: Dotfiles" })

        vim.keymap.set("n", "<leader>fs", function()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                local root = get_root()
                vim.schedule(function()
                    require("telescope.builtin").grep_string({
                        cwd = root,
                        search = input,
                        ---@diagnostic disable-next-line: param-type-mismatch
                        prompt_title = vim.fs.basename(root),
                        file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/" },
                    })
                end)
            end)
        end, { desc = "Telescope: Grep string" })

        vim.keymap.set("n", "<leader>ff", function()
            require("telescope.builtin").find_files({
                ---@diagnostic disable-next-line: param-type-mismatch
                prompt_title = vim.fs.basename(vim.loop.cwd()),
            })
        end, { desc = "Telescope: Find files" })

        vim.keymap.set("n", "<leader>fg", function()
            require("telescope.builtin").git_files({
                prompt_title = vim.fs.basename(git_root()),
                recurse_submodules = true,
                show_untracked = false,
            })
        end, { desc = "Telescope: Git files" })

        vim.keymap.set("n", "<leader>fp", function()
            require("telescope.builtin").find_files({
                cwd = vim.fn.stdpath("data") .. "/lazy",
                follow = true,
                prompt_title = "Plugins",
                search_dirs = vim.tbl_map(function(val)
                    return val.dir
                end, require("lazy").plugins()),
            })
        end, { desc = "Telescope: Plugins" })

        vim.keymap.set("n", "<leader>fn", function()
            require("telescope.builtin").find_files({
                cwd = "~/Applications/neovim",
                prompt_title = "Neovim",
                hidden = true,
                file_ignore_patterns = { ".git/" },
            })
        end, { desc = "Telescope: Neovim" })

        vim.keymap.set("n", "<leader>fq", function()
            require("seblj.cht").telescope_cht()
        end, { desc = "curl cht.sh" })

        vim.keymap.set("n", "<leader>fe", function()
            require("telescope").extensions.file_browser.file_browser()
        end, { desc = "Telescope: File Browser" })

        -- Thanks to TJ: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/custom/multi_rg.lua
        vim.keymap.set("n", "<leader>fw", function()
            local root = get_root()
            require("telescope.pickers")
                :new({
                    debounce = 100,
                    ---@diagnostic disable-next-line: param-type-mismatch
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
        end, { desc = "Telescope: Multi grep" })
    end,
}
