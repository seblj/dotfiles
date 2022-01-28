local augroup = require('seblj.utils').augroup
local keymap = vim.keymap.set
local plugin_dir = '~/projects/plugins/'

augroup('CompilePacker', {
    event = 'BufWritePost',
    pattern = 'plugins.lua',
    command = function()
        vim.cmd('PackerCompile')
    end,
})

local plugins = function(use)
    use({ 'wbthomason/packer.nvim' })

    -- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/plugins.lua
    local local_use = function(opts)
        local plugin = opts
        if type(opts) == 'table' then
            plugin = table.remove(opts, 1)
        end
        local plugin_name = vim.split(plugin, '/')[2]

        if vim.fn.isdirectory(vim.fn.expand(plugin_dir .. plugin_name)) == 1 then
            use(vim.tbl_extend('error', { plugin_dir .. plugin_name }, opts))
        else
            use(vim.tbl_extend('error', { plugin }, opts))
        end
    end

    local setup = function(name)
        return string.format([[require('%s').setup()]], name)
    end

    local conf = function(name)
        return string.format([[require('config.%s')]], name)
    end

    -- My plugins/forks
    local_use({ 'seblj/nvim-tabline', config = setup('tabline'), event = 'TabNew' })
    local_use({ 'seblj/nvim-echo-diagnostics', config = setup('echo-diagnostics') })

    -- Telescope
    use({ 'nvim-telescope/telescope.nvim', config = conf('telescope') })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use({ 'nvim-telescope/telescope-file-browser.nvim' })
    use({ 'nvim-lua/plenary.nvim' })

    -- Treesitter
    use({ 'nvim-treesitter/nvim-treesitter', config = conf('treesitter'), run = ':TSUpdate' })
    use({ 'nvim-treesitter/playground' })
    use({ 'windwp/nvim-ts-autotag' })
    use({ 'nvim-treesitter/nvim-treesitter-textobjects' })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring' })

    -- LSP
    use({ 'neovim/nvim-lspconfig', config = conf('lspconfig') })
    use({ 'jose-elias-alvarez/null-ls.nvim', config = conf('null-ls') })
    use({ 'folke/lua-dev.nvim' })
    use({ 'b0o/schemastore.nvim' })

    -- Completion
    use({ 'hrsh7th/nvim-cmp', config = conf('cmp'), branch = 'feat/completion-menu-borders' })
    use({ 'hrsh7th/cmp-cmdline' })
    use({ 'hrsh7th/cmp-nvim-lsp' })
    use({ 'hrsh7th/cmp-buffer' })
    use({ 'hrsh7th/cmp-path' })
    use({ 'saadparwaiz1/cmp_luasnip' })
    use({ 'L3MON4D3/LuaSnip', config = conf('luasnip') })
    use({ 'onsails/lspkind-nvim' })

    -- Git
    use({ 'pwntester/octo.nvim', config = setup('octo'), cmd = 'Octo' })
    use({ 'sindrets/diffview.nvim', config = conf('diffview'), cmd = { 'DiffviewOpen', 'DiffviewFileHistory' } })
    use({ 'lewis6991/gitsigns.nvim', config = conf('gitsigns'), event = { 'BufReadPre', 'BufWritePre' } })
    use({ 'rhysd/conflict-marker.vim', config = conf('conflict'), event = 'BufReadPre' })

    -- Test
    use({ 'vim-test/vim-test', config = conf('test'), cmd = { 'TestFile', 'TestNearest' } })
    use({ 'rcarriga/vim-ultest', run = ':UpdateRemotePlugins', cmd = { 'Ultest', 'UltestNearest' }, wants = 'vim-test' })

    -- Packageinfo
    use({ 'vuki656/package-info.nvim', config = conf('packageinfo'), ft = 'json' })
    use({ 'MunifTanjim/nui.nvim' })

    -- Latex
    use({ 'lervag/vimtex', config = conf('vimtex'), ft = { 'tex', 'bib' } })

    -- Debugging
    use({ 'mfussenegger/nvim-dap', config = conf('dap'), keys = '<leader>db' })
    use({ 'rcarriga/nvim-dap-ui' })

    -- Others
    use({ 'ThePrimeagen/refactoring.nvim', config = conf('refactoring'), keys = '<leader>fr' })
    use({ 'ThePrimeagen/harpoon', config = conf('harpoon'), disable = true })

    use({ 'kyazdani42/nvim-tree.lua', config = conf('luatree'), keys = { '<leader>tt' } })
    use({ 'elihunter173/dirbuf.nvim', config = conf('dirbuf') })
    -- use({ 'tamago324/lir.nvim', config = conf('lir') })
    use({ 'norcalli/nvim-colorizer.lua', config = setup('colorizer') })
    use({ 'mhinz/vim-startify', config = conf('startify') })
    use({ 'NTBBloodbath/galaxyline.nvim', config = conf('galaxyline') })
    use({ 'windwp/nvim-autopairs', config = conf('autopairs') })
    use({ 'rcarriga/nvim-notify', config = conf('notify') })
    use({ 'godlygeek/tabular', config = 'vim.g.no_default_tabular_maps = 1' })
    use({ 'github/copilot.vim', cmd = 'Copilot' })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'lewis6991/impatient.nvim' })
    use({ 'szw/vim-maximizer', config = keymap('n', '<leader>m', ':MaximizerToggle!<CR>', { desc = 'Maximize split' }) })
    use({ 'antoinemadec/FixCursorHold.nvim', config = 'vim.g.cursorhold_updatetime = 100' })
    use({ 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = 'markdown' })
    use({ 'dstein64/vim-startuptime', config = conf('startuptime'), cmd = 'StartupTime' })
    use({ 'NTBBloodbath/rest.nvim', ft = 'http' })
    use({ 'mbbill/undotree', cmd = 'UndotreeToggle' })
    use({ 'lambdalisue/suda.vim' })
    use({ 'wellle/targets.vim' })
    use({ 'tpope/vim-repeat' })
    use({ 'tpope/vim-abolish' })
    use({ 'tpope/vim-surround' })
    use({ 'tpope/vim-commentary' })
    use({ 'tpope/vim-scriptease' })
    use({ 'tpope/vim-sleuth' })
end

return require('packer').startup({
    plugins,
    config = {
        profile = {
            enable = true,
        },
        display = {
            prompt_border = 'rounded',
        },
    },
})
