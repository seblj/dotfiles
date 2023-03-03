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
        local utils = require("config.telescope.utils")
        local function map(mode, keys, module, func, desc)
            vim.keymap.set(mode, keys, function()
                if module == "utils" then
                    utils[func]()
                elseif module == "builtin" then
                    require("telescope.builtin")[func]()
                end
            end, { desc = string.format("Telescope: %s", desc) })
        end

        map("n", "<leader>fd", "utils", "edit_dotfiles", "Dotfiles")
        map("n", "<leader>fw", "utils", "multi_grep", "Multi grep")
        map("n", "<leader>fo", "builtin", "oldfiles", "Oldfiles")
        map("n", "<leader>fb", "builtin", "buffers", "Buffers")
        map("n", "<leader>fk", "builtin", "keymaps", "Keymaps")
        map("n", "<leader>fa", "builtin", "autocommands", "Autocommands")
        map("n", "<leader>fh", "builtin", "help_tags", "Helptags")
        map("n", "<leader>fc", "builtin", "command_history", "Command history")
        map("n", "<leader>vo", "builtin", "vim_options", "Vim options")

        vim.keymap.set("n", "<leader>fs", function()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                local root = utils.get_root()
                vim.schedule(function()
                    require("telescope.builtin").grep_string({
                        cwd = root,
                        search = input,
                        prompt_title = vim.fs.basename(root),
                        file_ignore_patterns = { "%.git/", "hammerspoon/Spoons/" },
                    })
                end)
            end)
        end)

        vim.keymap.set("n", "<leader>ff", function()
            require("telescope.builtin").find_files({
                ---@diagnostic disable-next-line: param-type-mismatch
                prompt_title = vim.fs.basename(vim.loop.cwd()),
            })
        end)

        vim.keymap.set("n", "<leader>fg", function()
            require("telescope.builtin").git_files({
                prompt_title = vim.fs.basename(utils.get_git_root()),
                recurse_submodules = true,
                show_untracked = false,
            })
        end)

        vim.keymap.set("n", "<leader>fp", function()
            require("telescope.builtin").find_files({
                cwd = vim.fn.stdpath("data") .. "/lazy",
                follow = true,
                prompt_title = "Plugins",
                search_dirs = vim.tbl_map(function(val)
                    return val.dir
                end, require("lazy").plugins()),
            })
        end)

        vim.keymap.set("n", "<leader>fn", function()
            require("telescope.builtin").find_files({
                cwd = "~/Applications/neovim",
                prompt_title = "Neovim",
                hidden = true,
                file_ignore_patterns = { ".git/" },
            })
        end)

        vim.keymap.set("n", "<leader>fq", function()
            require("seblj.cht").telescope_cht()
        end, { desc = "curl cht.sh" })

        vim.keymap.set("n", "<leader>fe", function()
            require("telescope").extensions.file_browser.file_browser()
        end, { desc = "Telescope: File Browser" })
    end,
}
