local lazy = require('config.lazy')
local conf = lazy.conf
local setup = lazy.setup

require('lazy').setup({
    -- My plugins/forks
    {
        'seblj/nvim-tabline',
        config = setup('tabline'),
        event = 'TabNew',
        dependencies = {
            { 'kyazdani42/nvim-web-devicons' },
        },
    },
    { 'seblj/nvim-echo-diagnostics', config = setup('echo-diagnostics') },
    { 'seblj/formatter.nvim', config = conf('formatter'), dependencies = { 'nvim-lua/plenary.nvim' } },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        config = conf('telescope'),
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-lua/plenary.nvim' },
            { 'kyazdani42/nvim-web-devicons' },
        },
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        config = conf('treesitter'),
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
            { 'windwp/nvim-ts-autotag' },
            { 'nvim-treesitter/nvim-treesitter-textobjects' },
        },
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        config = conf('lspconfig'),
        event = 'BufReadPre',
        dependencies = {
            { 'folke/neodev.nvim' },
            { 'b0o/schemastore.nvim' },
            { 'williamboman/mason.nvim', config = setup('mason'), cmd = 'Mason' },
            { 'williamboman/mason-lspconfig.nvim', config = setup('mason-lspconfig'), cmd = 'LspInstall' },
            { 'Hoffs/omnisharp-extended-lsp.nvim' },
            { 'SmiteshP/nvim-navic' },
        },
    },
    { 'j-hui/fidget.nvim', config = setup('fidget', { text = { spinner = 'dots' } }) },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        config = conf('cmp'),
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'L3MON4D3/LuaSnip', config = conf('luasnip') },
        },
    },

    -- Database
    {
        'kristijanhusak/vim-dadbod-ui',
        config = conf('dadbod'),
        cmd = 'DBUI',
        dependencies = {
            { 'kristijanhusak/vim-dadbod-completion' },
            { 'tpope/vim-dadbod' },
        },
    },

    -- Git
    { 'lewis6991/gitsigns.nvim', config = conf('gitsigns'), event = { 'BufReadPre', 'BufWritePre' } },
    { 'akinsho/git-conflict.nvim', config = setup('git-conflict', { highlights = { current = 'DiffChange' } }) },

    -- Packageinfo
    {
        'saecki/crates.nvim',
        config = setup('crates'),
        event = 'BufReadPre Cargo.toml',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
    },
    {
        'vuki656/package-info.nvim',
        config = conf('packageinfo'),
        event = 'BufReadPre package.json',
        dependencies = {
            { 'MunifTanjim/nui.nvim' },
        },
    },

    -- Latex
    { 'lervag/vimtex', config = conf('vimtex'), ft = { 'tex', 'bib' } },

    -- Debugging
    {
        'mfussenegger/nvim-dap',
        config = conf('dap'),
        dependencies = {
            { 'rcarriga/nvim-dap-ui' },
        },
        keys = { '<leader>db' },
    },

    -- File tree
    {
        'kyazdani42/nvim-tree.lua',
        config = conf('nvimtree'),
        keys = { '<leader>nt' },
        dependencies = {
            { 'kyazdani42/nvim-web-devicons' },
        },
    },
    { 'tamago324/lir.nvim', config = conf('lir') },

    -- UI
    { 'NvChad/nvim-colorizer.lua', config = setup('colorizer', { user_default_options = { names = false } }) },
    { 'mhinz/vim-startify', config = conf('startify') },
    {
        'feline-nvim/feline.nvim',
        config = conf('feline'),
        dependencies = {
            { 'kyazdani42/nvim-web-devicons' },
            { 'SmiteshP/nvim-navic' },
        },
    },
    { 'rcarriga/nvim-notify', config = conf('notify') },

    {
        'windwp/nvim-autopairs',
        config = setup('nvim-autopairs', { ignored_next_char = '[%w%.%{%[%(%"%\']' }),
        event = 'InsertEnter',
    },
    {
        'godlygeek/tabular',
        init = function()
            vim.g.no_default_tabular_maps = 1
        end,
    },
    { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', cmd = 'MarkdownPreviewToggle' },
    { 'dstein64/vim-startuptime', config = conf('startuptime'), cmd = 'StartupTime' },
    {
        'NTBBloodbath/rest.nvim',
        ft = 'http',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
    },
    { 'mbbill/undotree', cmd = 'UndotreeToggle' },
    {
        'lambdalisue/suda.vim',
        config = function()
            vim.cmd.cnoreabbrev({ 'w!!', 'w suda://%' })
        end,
    },

    -- Tpope
    { 'tpope/vim-repeat' },
    { 'tpope/vim-abolish' },
    { 'tpope/vim-surround', config = conf('surround') },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-scriptease' },
    { 'tpope/vim-sleuth' },
}, {
    dev = {
        path = '~/projects/plugins',
        patterns = { 'seblj' },
    },
    ui = {
        border = CUSTOM_BORDER,
    },
})
