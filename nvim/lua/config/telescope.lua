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
                file_ignore_patterns = { "%.git[/\\]", "hammerspoon[/\\]Spoons", "^fonts[/\\]", "^icons[/\\]" },
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
            require("telescope.builtin").find_files({ prompt_title = vim.fs.basename(vim.uv.cwd()) })
        end, { desc = "Telescope: Find files" })

        vim.keymap.set("n", "<leader>fg", function()
            require("telescope.builtin").git_files({ prompt_title = vim.fs.basename(vim.fs.root(0, ".git")) })
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
    helpers = {
        on_list = function(opts)
            ---@param res vim.lsp.LocationOpts.OnList
            return function(res)
                -- Filter out all items that that has the same line number and filename
                -- Don't need "duplicates" in the list
                local seen = {}
                local filtered_items = vim.iter(res.items)
                    :map(function(item)
                        local key = string.format("%s:%s", item.filename, item.lnum)
                        if not seen[key] then
                            seen[key] = true
                            return item
                        end
                    end)
                    :totable()

                if #filtered_items == 1 then
                    -- NOTE: Not necessarily the best option because I am hardcoding `utf-8`, but it
                    -- requires the least amount of code. Switch out with `vim.jump` if that ever becomes
                    -- a thing
                    return vim.lsp.util.show_document(filtered_items[1].user_data, "utf-8")
                end

                local conf = require("telescope.config").values
                require("telescope.pickers")
                    .new(opts, {
                        finder = require("telescope.finders").new_table({
                            results = filtered_items,
                            entry_maker = require("telescope.make_entry").gen_from_quickfix(opts),
                        }),
                        previewer = conf.qflist_previewer(opts),
                        sorter = conf.generic_sorter(opts),
                        push_cursor_on_edit = true,
                        push_tagstack_on_edit = true,
                    })
                    :find()
            end
        end,
    },
}
