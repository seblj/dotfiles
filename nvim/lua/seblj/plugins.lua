local lazy = require("config.lazy")
local conf = lazy.conf
local init = lazy.init

lazy.setup({
    -- My plugins/forks
    { "seblj/nvim-tabline", config = true, event = "TabNew", dev = true },
    { "seblj/nvim-formatter", config = conf("formatter"), dev = true },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        config = conf("telescope"),
        init = init("telescope"),
        cmd = "Telescope",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "nvim-telescope/telescope-file-browser.nvim" },
        },
    },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", config = conf("treesitter"), build = ":TSUpdate", branch = "main" },
    -- { "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost", "BufNewFile" } },
    { "seblj/nvim-ts-autotag", config = true, event = { "BufReadPost", "BufNewFile" }, dev = true },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        config = conf("lspconfig"),
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim", config = true },
            { "b0o/schemastore.nvim" },
            { "williamboman/mason.nvim", config = true, cmd = "Mason" },
            { "williamboman/mason-lspconfig.nvim", config = true, cmd = { "LspInstall", "LspUninstall" } },
            { "Hoffs/omnisharp-extended-lsp.nvim" },
            { "seblj/nvim-lsp-extras", opts = { global = { border = CUSTOM_BORDER } }, dev = true },
        },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        config = conf("cmp"),
        event = "InsertEnter",
        dependencies = {
            { "onsails/lspkind.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "L3MON4D3/LuaSnip", config = conf("luasnip") },
        },
    },

    {
        "github/copilot.vim",
        config = function()
            vim.g.copilot_filetypes = { ["*"] = false }
        end,
    },

    -- Database
    {
        "kristijanhusak/vim-dadbod-ui",
        cmd = "DBUI",
        dependencies = { "kristijanhusak/vim-dadbod-completion", "tpope/vim-dadbod" },
        config = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.keymap.set("n", "[s", "<Plug>(DBUI_GotoPrevSibling)")
            vim.keymap.set("n", "]s", "<Plug>(DBUI_GotoNextSibling)")
        end,
    },

    -- Git
    { "seblj/blame.nvim", config = true, dev = true, cmd = "BlameToggle" },
    { "lewis6991/gitsigns.nvim", config = conf("gitsigns"), event = { "BufReadPre", "BufWritePre" } },
    { "akinsho/git-conflict.nvim", config = true, event = { "BufReadPre", "BufWritePre" } },

    -- Packageinfo
    { "saecki/crates.nvim", config = true, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", config = true, event = "BufReadPre package.json" },

    { "lervag/vimtex", config = conf("vimtex"), ft = { "tex", "bib" } },

    -- File tree
    { "nvim-tree/nvim-tree.lua", config = true, keys = { { "<leader>nt", ":NvimTreeToggle<CR>" } } },
    { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true } } },

    -- UI
    {
        "NvChad/nvim-colorizer.lua",
        opts = { user_default_options = { names = false } },
        event = { "BufReadPre", "BufNewFile" },
    },
    { "mhinz/vim-startify", config = conf("startify") },
    { "freddiehaddad/feline.nvim" },
    {
        "Bekaboo/dropbar.nvim",
        opts = {
            general = {
                enable = function(buf, win)
                    return not vim.api.nvim_win_get_config(win).zindex
                        and vim.bo[buf].buftype == ""
                        and vim.api.nvim_buf_get_name(buf) ~= ""
                        and not vim.wo[win].diff
                end,
            },
        },
        cond = not (vim.uv.os_uname().sysname == "Windows_NT"),
    },
    { "j-hui/fidget.nvim", opts = { notification = { override_vim_notify = true } } },

    -- Functionality
    { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = "markdown" },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },
    { "ahonn/resize.vim" },

    { "windwp/nvim-autopairs", opts = { ignored_next_char = "[%w%.%{%[%(%\"%']" }, event = "InsertEnter" },
    { "lambdalisue/suda.vim", keys = { { "w!!", "SudaWrite", mode = "ca" } }, lazy = false },
    { "godlygeek/tabular", cmd = "Tabularize" },

    -- Dependencies/helpers for other plugins
    { "nvim-lua/plenary.nvim", lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Tpope
    { "tpope/vim-repeat" },
    { "tpope/vim-abolish" },
    {
        "tpope/vim-surround",
        keys = {
            { "s", "<Plug>Ysurround", desc = "Surround with motion" },
            { "S", "<Plug>Yssurround", desc = "Surround entire line" },
            { "s", "<Plug>VSurround", mode = "x", desc = "Surround visual" },
        },
        lazy = false,
    },
    { "tpope/vim-commentary", config = conf("commentstring") },
    { "tpope/vim-scriptease" },
    { "tpope/vim-sleuth" },
})
