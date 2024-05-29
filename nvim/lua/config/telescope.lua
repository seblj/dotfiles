return {
    "nvim-telescope/telescope.nvim",
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = { hidden = true },
                git_files = { recurse_submodules = true },
            },
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
        vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<CR>")
        vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
        vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>")
        vim.keymap.set("n", "<leader>fa", ":Telescope autocommands<CR>")
        vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
        vim.keymap.set("n", "<leader>fc", ":Telescope command_history<CR>")
        vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<CR>")
        vim.keymap.set("n", "<leader>fd", ":Telescope find_files prompt_title=Dotfiles cwd=~/dotfiles<CR>")
        vim.keymap.set("n", "<leader>fn", ":Telescope find_files prompt_title=Neovim cwd=~/Applications/neovim<CR>")

        vim.keymap.set("n", "<leader>ff", function()
            require("telescope.builtin").find_files({ prompt_title = vim.fs.basename(vim.uv.cwd()) })
        end, { desc = "Telescope: Find files" })
        vim.keymap.set("n", "<leader>fg", function()
            require("telescope.builtin").git_files({ prompt_title = vim.fs.basename(vim.fs.root(0, ".git")) })
        end, { desc = "Telescope: Git files" })

        vim.keymap.set("n", "<leader>fp", function()
            require("telescope.builtin").find_files({
                cwd = vim.fn.stdpath("data") .. "/lazy",
                prompt_title = "Plugins",
                search_dirs = vim.iter(require("lazy").plugins())
                    :map(function(val)
                        return val.dir
                    end)
                    :totable(),
            })
        end, { desc = "Telescope: Find plugins" })

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
