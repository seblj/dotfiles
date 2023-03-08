local lazy = require("config.lazy")
local conf = lazy.conf
local init = lazy.init

lazy.setup({
    -- My plugins/forks
    { "seblj/nvim-tabline", config = true, event = "TabNew", dev = true },
    { "seblj/nvim-echo-diagnostics", config = true, dev = true },
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
    {
        "nvim-treesitter/nvim-treesitter",
        config = conf("treesitter"),
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle" } },
            { "windwp/nvim-ts-autotag" },
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
    },

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
            { "j-hui/fidget.nvim", opts = { text = { spinner = "dots" } } },
            { "SmiteshP/nvim-navic" },
            {
                "seblj/nvim-lsp-extras",
                opts = {
                    signature = { border = CUSTOM_BORDER },
                    mouse_hover = { border = CUSTOM_BORDER },
                },
                dev = true,
            },
        },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        config = conf("cmp"),
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "L3MON4D3/LuaSnip", config = conf("luasnip") },
        },
    },

    -- Database
    {
        "kristijanhusak/vim-dadbod-ui",
        config = conf("dadbod"),
        cmd = "DBUI",
        dependencies = { "kristijanhusak/vim-dadbod-completion", "tpope/vim-dadbod" },
    },

    -- -- Git
    { "lewis6991/gitsigns.nvim", config = conf("gitsigns"), event = { "BufReadPre", "BufWritePre" } },
    {
        "akinsho/git-conflict.nvim",
        opts = { highlights = { current = "DiffChange" } },
        event = { "BufReadPre", "BufWritePre" },
    },

    -- Packageinfo
    { "saecki/crates.nvim", config = true, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", config = true, event = "BufReadPre package.json" },

    -- Latex
    { "lervag/vimtex", config = conf("vimtex"), ft = { "tex", "bib" } },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        config = conf("dap"),
        dependencies = { "rcarriga/nvim-dap-ui" },
        keys = { "<leader>db" },
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        config = true,
        keys = { { "<leader>nt", ":NvimTreeToggle<CR>", desc = "NvimTree: Toggle tree" } },
    },
    { "tamago324/lir.nvim", config = conf("lir"), event = "VimEnter" },

    -- -- UI
    {
        "NvChad/nvim-colorizer.lua",
        opts = { user_default_options = { names = false } },
        event = { "BufReadPre", "BufNewFile" },
    },
    { "mhinz/vim-startify", config = conf("startify") },
    { "freddiehaddad/feline.nvim", config = conf("feline") },
    { "rcarriga/nvim-notify", config = conf("notify"), init = init("notify"), lazy = true },

    -- Functionality
    { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()" },
    { "NTBBloodbath/rest.nvim", ft = "http" },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },

    { "windwp/nvim-autopairs", opts = { ignored_next_char = "[%w%.%{%[%(%\"%']" }, event = "InsertEnter" },
    {
        "godlygeek/tabular",
        init = function()
            vim.g.no_default_tabular_maps = 1
        end,
    },
    {
        "lambdalisue/suda.vim",
        config = function()
            vim.cmd.cnoreabbrev({ "w!!", "SudaWrite" })
        end,
    },

    -- Dependencies/helpers for other plugins
    { "nvim-lua/plenary.nvim", lazy = true },
    { "MunifTanjim/nui.nvim", lazy = true },
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
    { "tpope/vim-commentary" },
    { "tpope/vim-scriptease" },
    { "tpope/vim-sleuth" },
})
