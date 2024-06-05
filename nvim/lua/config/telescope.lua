return {
    "nvim-telescope/telescope.nvim",
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = { hidden = true },
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
        local use_git_root = true
        vim.keymap.set("n", "<leader>tg", function()
            use_git_root = not use_git_root
            local cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()
            vim.notify(string.format("Searching from %s", cwd))
        end)

        vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<CR>")
        vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
        vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>")
        vim.keymap.set("n", "<leader>fa", ":Telescope autocommands<CR>")
        vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
        vim.keymap.set("n", "<leader>fc", ":Telescope command_history<CR>")
        vim.keymap.set("n", "<leader>fd", ":Telescope find_files prompt_title=Dotfiles cwd=~/dotfiles<CR>")
        vim.keymap.set("n", "<leader>fn", ":Telescope find_files prompt_title=Neovim cwd=~/Applications/neovim<CR>")

        vim.keymap.set("n", "<leader>ff", function()
            local cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()
            require("telescope.builtin").find_files({
                cwd = cwd,
                prompt_title = vim.fs.basename(cwd),
            })
        end, { desc = "Telescope: Find files" })

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

        vim.keymap.set("n", "<leader>fw", function()
            require("telescope.builtin").live_grep({
                cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd(),
            })
        end)

        vim.keymap.set("n", "<leader>fs", function()
            local cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                vim.schedule(function()
                    require("telescope.builtin").grep_string({
                        cwd = cwd,
                        search = input,
                        prompt_title = vim.fs.basename(cwd),
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
