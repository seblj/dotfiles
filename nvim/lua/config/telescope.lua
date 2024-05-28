return {
    "nvim-telescope/telescope.nvim",
    config = function()
        require("telescope").setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                layout_strategy = "flex",
                layout_config = { flex = { flip_columns = 120 } },
                file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/", "^fonts/", "^icons/" },
                mappings = {
                    i = {
                        ["<C-j>"] = require("telescope.actions.layout").cycle_layout_next,
                        ["<C-k>"] = require("telescope.actions.layout").cycle_layout_prev,
                    },
                },
            },
        })

        require("telescope").load_extension("fzf")
    end,
    init = function()
        local function map(keys, func, desc, opts)
            vim.keymap.set("n", keys, function()
                require("telescope.builtin")[func](opts and opts() or {})
            end, { desc = string.format("Telescope: %s", desc) })
        end

        map("<leader>fo", "oldfiles", "Oldfiles")
        map("<leader>fb", "buffers", "Buffers")
        map("<leader>fk", "keymaps", "Keymaps")
        map("<leader>fa", "autocommands", "Autocommands")
        map("<leader>fh", "help_tags", "Helptags")
        map("<leader>fc", "command_history", "Command history")
        map("<leader>fd", "find_files", "Dotfiles", function()
            return { cwd = "~/dotfiles", prompt_title = "Dotfiles", hidden = true }
        end)
        map("<leader>ff", "find_files", "Find files", function()
            return { prompt_title = vim.fs.basename(vim.uv.cwd()) }
        end)
        map("<leader>fg", "git_files", "Git files", function()
            return { prompt_title = vim.fs.basename(vim.fs.root(0, ".git")), recurse_submodules = true }
        end)
        map("<leader>fw", "live_grep", "Live grep")
        map("<leader>fp", "find_files", "Plugins", function()
            return {
                cwd = vim.fn.stdpath("data") .. "/lazy",
                prompt_title = "Plugins",
                search_dirs = vim.iter(require("lazy").plugins())
                    :map(function(val)
                        return val.dir
                    end)
                    :totable(),
            }
        end)
        map("<leader>fn", "find_files", "Neovim", function()
            return { cwd = "~/Applications/neovim", prompt_title = "Neovim", hidden = true }
        end)

        vim.keymap.set("n", "<leader>fs", function()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                vim.schedule(function()
                    require("telescope.builtin").grep_string({
                        search = input,
                        prompt_title = vim.fs.basename(vim.uv.cwd()),
                    })
                end)
            end)
        end, { desc = "Telescope: Grep string" })
    end,
    cmd = "Telescope",
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-lua/plenary.nvim" },
    },
}
