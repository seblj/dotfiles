local packer = require('config.packer')
local conf = packer.conf
local setup = packer.setup

packer.add({
    { 'lewis6991/packer.nvim', branch = 'main' },
    { 'lewis6991/impatient.nvim', start = true },

    -- My plugins/forks
    { 'seblj/nvim-tabline', config = setup('tabline'), event = 'TabNew' },
    { 'seblj/nvim-echo-diagnostics', config = setup('echo-diagnostics') },
    { 'seblj/formatter.nvim', config = conf('formatter') },

    -- Telescope
    { 'nvim-telescope/telescope.nvim', config = conf('telescope') },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'nvim-lua/plenary.nvim' },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', config = conf('treesitter'), run = ':TSUpdate' },
    { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' } },
    { 'windwp/nvim-ts-autotag' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },

    -- LSP
    { 'neovim/nvim-lspconfig', config = conf('lspconfig') },
    { 'folke/neodev.nvim' },
    { 'b0o/schemastore.nvim' },
    { 'j-hui/fidget.nvim', config = setup('fidget', { text = { spinner = 'dots' } }) },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'Hoffs/omnisharp-extended-lsp.nvim' },
    { 'SmiteshP/nvim-navic' },

    -- Completion
    { 'hrsh7th/nvim-cmp', config = conf('cmp') },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'L3MON4D3/LuaSnip', config = conf('luasnip') },

    -- Database
    { 'kristijanhusak/vim-dadbod-ui', config = conf('dadbod') },
    { 'kristijanhusak/vim-dadbod-completion' },
    { 'tpope/vim-dadbod' },

    -- Git
    { 'lewis6991/gitsigns.nvim', config = conf('gitsigns'), event = { 'BufReadPre', 'BufWritePre' } },
    { 'akinsho/git-conflict.nvim', config = setup('git-conflict', { highlights = { current = 'DiffChange' } }) },

    -- Packageinfo
    { 'saecki/crates.nvim', config = setup('crates'), event = 'BufRead Cargo.toml' },
    { 'vuki656/package-info.nvim', config = conf('packageinfo'), event = 'BufRead package.json' },
    { 'MunifTanjim/nui.nvim' },

    -- Latex
    { 'lervag/vimtex', config_pre = conf('vimtex'), ft = { 'tex', 'bib' } },

    -- Debugging
    { 'mfussenegger/nvim-dap', config = conf('dap'), keys = { { 'n', '<leader>db' } } },
    { 'rcarriga/nvim-dap-ui' },

    -- File tree
    { 'kyazdani42/nvim-tree.lua', config = conf('nvimtree'), keys = { '<leader>nt' } },
    { 'tamago324/lir.nvim', config = conf('lir') },

    -- UI
    { 'NvChad/nvim-colorizer.lua', config = setup('colorizer', { user_default_options = { names = false } }) },
    { 'mhinz/vim-startify', config = conf('startify') },
    { 'kyazdani42/nvim-web-devicons' },
    { 'feline-nvim/feline.nvim', config = conf('feline') },
    { 'rcarriga/nvim-notify', config = conf('notify') },

    { 'windwp/nvim-autopairs', config = setup('nvim-autopairs', { ignored_next_char = '[%w%.%{%[%(%"%\']' }) },
    { 'godlygeek/tabular', config_pre = 'vim.g.no_default_tabular_maps = 1' },
    { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' },
    { 'dstein64/vim-startuptime', config = conf('startuptime'), cmd = 'StartupTime' },
    { 'NTBBloodbath/rest.nvim', ft = 'http' },
    { 'mbbill/undotree', cmd = 'UndotreeToggle' },
    { 'lambdalisue/suda.vim', config = 'vim.cmd.cnoreabbrev({ "w!!", "w suda://%" })' },

    -- Tpope
    { 'tpope/vim-repeat' },
    { 'tpope/vim-abolish' },
    { 'tpope/vim-surround', config = conf('surround') },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-scriptease' },
    { 'tpope/vim-sleuth' },
})
