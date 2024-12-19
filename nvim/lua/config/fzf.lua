return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        local use_git_root = true
        vim.keymap.set("n", "<leader>tg", function()
            use_git_root = not use_git_root
            local cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()
            vim.notify(string.format("Searching from %s", cwd))
        end)

        vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>")
        vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
        vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>")
        vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua autocommands<CR>")
        vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<CR>")
        vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua command_history<CR>")
        vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua files cwd=~/dotfiles<CR>")
        vim.keymap.set("n", "<leader>fn", "<cmd>FzfLua files cwd=~/Applications/neovim<CR>")
        vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")
        vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua git_files<CR>")
        vim.keymap.set("n", "<leader>fw", function()
            require("fzf-lua").live_grep({
                cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd(),
            })
        end)
        vim.keymap.set("n", "<leader>fp", function()
            local plugins = vim.iter(require("lazy").plugins())
                :map(function(val)
                    return val.dir
                end)
                :totable()

            require("fzf-lua").files({
                cmd = string.format("fd -t f . %s", table.concat(plugins, " ")),
                cwd = vim.fn.stdpath("data") .. "/lazy",
            })
        end)

        vim.keymap.set("n", "<leader>fs", function()
            local cwd = use_git_root and vim.fs.root(0, ".git") or vim.uv.cwd()
            vim.ui.input({ prompt = "Grep String: " }, function(input)
                vim.schedule(function()
                    require("fzf-lua.providers.grep").grep({
                        search = input,
                        cwd = cwd,
                    })
                end)
            end)
        end)
    end,
    config = function()
        local actions = require("fzf-lua.actions")
        require("fzf-lua").setup({
            "telescope",
            file_ignore_patterns = { "%.git[/\\]", "hammerspoon[/\\]Spoons", "^fonts[/\\]", "^icons[/\\]" },
            keymap = {
                actions = {
                    ["ctrl-x"] = actions.keymap_split,
                },
                fzf = {
                    esc = false,
                },
            },
            winopts = {
                on_create = function()
                    vim.keymap.set("n", "<Esc>", require("fzf-lua").hide, { buffer = true })
                end,
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "fzf",
            callback = function()
                vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25"
                vim.wo[0][0].cursorline = false
            end,
        })
    end,
}
