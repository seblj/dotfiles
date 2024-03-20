return {
    "nvim-telescope/telescope.nvim",
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
                file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/", "^fonts/", "^icons/" },
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
    end,
    init = function()
        local function map(keys, func, desc, opts)
            vim.keymap.set("n", keys, function()
                require("telescope.builtin")[func](opts and opts() or {})
            end, { desc = string.format("Telescope: %s", desc) })
        end

        local use_git_root = true
        vim.keymap.set("n", "<leader>tg", function()
            use_git_root = not use_git_root
            local using = use_git_root and "git root" or "current dir"
            vim.notify(string.format("Using %s in telescope", using))
        end, {
            desc = "Telescope: Toggle root dir between git and cwd",
        })

        local function git_root()
            return vim.trim(vim.system({ "git", "rev-parse", "--show-toplevel" }, { cwd = vim.uv.cwd() }):wait().stdout)
        end

        local function get_root()
            return use_git_root and git_root() or vim.uv.cwd()
        end

        map("<leader>fo", "oldfiles", "Oldfiles")
        map("<leader>fb", "buffers", "Buffers")
        map("<leader>fk", "keymaps", "Keymaps")
        map("<leader>fa", "autocommands", "Autocommands")
        map("<leader>fh", "help_tags", "Helptags")
        map("<leader>fc", "command_history", "Command history")
        map("<leader>vo", "vim_options", "Vim options")
        map("<leader>fd", "find_files", "Dotfiles", function()
            return { cwd = "~/dotfiles", prompt_title = "Dotfiles", hidden = true }
        end)
        map("<leader>ff", "find_files", "Find files", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            return { prompt_title = vim.fs.basename(vim.uv.cwd()) }
        end)
        map("<leader>fg", "git_files", "Git files", function()
            return { prompt_title = vim.fs.basename(git_root()), recurse_submodules = true }
        end)
        map("<leader>fp", "find_files", "Plugins", function()
            return {
                cwd = vim.fn.stdpath("data") .. "/lazy",
                prompt_title = "Plugins",
                search_dirs = vim.iter.map(function(val)
                    return val.dir
                end, require("lazy").plugins()),
            }
        end)
        map("<leader>fn", "find_files", "Neovim", function()
            return { cwd = "~/Applications/neovim", prompt_title = "Neovim", hidden = true }
        end)

        vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<CR>", { desc = "Telescope: File Browser" })

        vim.keymap.set("n", "<leader>fs", function()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                local root = get_root()
                vim.schedule(function()
                    require("telescope.builtin").grep_string({
                        cwd = root,
                        search = input,
                        prompt_title = vim.fs.basename(root),
                    })
                end)
            end)
        end, { desc = "Telescope: Grep string" })

        -- Thanks to TJ: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/custom/multi_rg.lua
        vim.keymap.set("n", "<leader>fw", function()
            local root = get_root()
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

                            return vim.tbl_flatten({
                                args,
                                { "-H", "-n", "-S", "-F", "--column", "-g", "!Spoons/" },
                            })
                        end,
                    }),
                })
                :find()
        end, { desc = "Telescope: Multi grep" })
    end,
    cmd = "Telescope",
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-lua/plenary.nvim" },
    },
}
