local augroup = require('seblj.utils').augroup
local nnoremap = vim.keymap.nnoremap

local plugin_dir = '~/projects/plugins/'

augroup('CompilePacker', {
    event = 'BufWritePost',
    pattern = 'plugins.lua',
    command = function()
        vim.cmd('PackerCompile')
    end,
})

local setup = function(name)
    require(name).setup()
end

local conf = function(name)
    return string.format([[require('config.%s')]], name)
end

return require('packer').startup({
    function(use)
        use({ 'wbthomason/packer.nvim' }) -- Package manager

        -- Uses local plugin if exists. Install from github if not
        -- Idea from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/plugins.lua.
        -- Extend this from tj to allow options
        local local_use = function(first)
            local opts = {}
            local plugin = first
            if type(first) == 'table' then
                plugin = vim.tbl_flatten(first)[1]
                -- Get all the options
                for k, v in pairs(first) do
                    if type(k) ~= 'number' and k ~= 'upstream' then
                        opts[k] = v
                    end
                end
            end
            local plugin_list = vim.split(plugin, '/')
            local username = plugin_list[1]
            local plugin_name = plugin_list[2]

            local use_tbl = {}
            if vim.fn.isdirectory(vim.fn.expand(plugin_dir .. plugin_name)) == 1 and first['upstream'] ~= true then
                table.insert(use_tbl, plugin_dir .. plugin_name)
            else
                if first['force_local'] then
                    return
                end
                table.insert(use_tbl, string.format('%s/%s', username, plugin_name))
            end

            use(vim.tbl_extend('error', use_tbl, opts))
        end

        -- My plugins/forks
        local_use({ 'seblj/nvim-tabline', config = setup('tabline'), event = 'TabNew' }) -- Tabline
        local_use({ 'seblj/nvim-echo-diagnostics', config = setup('echo-diagnostics') }) -- Echo lspconfig diagnostics

        -- Telescope
        use({ 'nvim-telescope/telescope.nvim', config = conf('telescope') })
        use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
        use({ 'nvim-lua/plenary.nvim' })

        -- Treesitter
        use({ 'nvim-treesitter/nvim-treesitter', config = conf('treesitter'), run = "vim.cmd('TSUpdate')" }) -- Parser tool syntax
        use({ 'nvim-treesitter/playground' }) -- Display information from treesitter
        use({ 'windwp/nvim-ts-autotag' }) -- Autotag using treesitter
        use({ 'nvim-treesitter/nvim-treesitter-textobjects' }) -- Manipulate text using treesitter
        use({ 'JoosepAlviste/nvim-ts-context-commentstring' }) -- Auto switch commentstring with treesitter

        -- LSP
        use({ 'neovim/nvim-lspconfig', config = conf('lspconfig') }) -- Built-in LSP
        use({ 'jose-elias-alvarez/null-ls.nvim' })
        use({ 'folke/lua-dev.nvim' })
        use({ 'L3MON4D3/LuaSnip', config = conf('luasnip') })

        -- Completion
        use({ 'hrsh7th/nvim-cmp', config = conf('cmp') }) -- Completion
        use({ 'hrsh7th/cmp-nvim-lsp' })
        use({ 'hrsh7th/cmp-buffer' })
        use({ 'hrsh7th/cmp-path' })
        use({ 'saadparwaiz1/cmp_luasnip' })

        -- Git
        use({ 'pwntester/octo.nvim', config = setup('octo') })
        use({ 'sindrets/diffview.nvim', config = conf('diffview'), cmd = { 'DiffviewOpen', 'DiffviewFileHistory' } })
        use({ 'lewis6991/gitsigns.nvim', config = conf('gitsigns'), event = { 'BufReadPre', 'BufWritePre' } })
        use({ 'rhysd/conflict-marker.vim', config = conf('conflict'), event = 'BufReadPre' })

        -- Test
        use({ 'vim-test/vim-test', config = conf('test'), cmd = { 'TestFile', 'TestNearest', 'TestLast' } })
        use({ 'rcarriga/vim-ultest', run = ':UpdateRemotePlugins', cond = false })

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

        use({ 'kyazdani42/nvim-tree.lua', config = conf('luatree'), keys = { '<leader>tt' } })
        use({ 'ThePrimeagen/harpoon', config = conf('harpoon') })
        use({ 'norcalli/nvim-colorizer.lua', config = setup('colorizer') }) -- Color highlighter
        use({ 'mhinz/vim-startify', config = conf('startify') }) -- Startup screen
        use({ 'glepnir/galaxyline.nvim', config = conf('galaxyline') }) -- Statusline
        use({ 'tamago324/lir.nvim', config = conf('lir') }) -- File explorer
        use({ 'windwp/nvim-autopairs', config = conf('autopairs') }) -- Auto pairs
        use({ 'rcarriga/nvim-notify', config = conf('notify') }) -- Pretty notifications
        use({ 'godlygeek/tabular', config = 'vim.g.no_default_tabular_maps = 1' }) -- Line up text
        use({ 'github/copilot.vim', cmd = 'Copilot' }) -- Github copilot
        use({ 'kyazdani42/nvim-web-devicons' }) -- Icons
        use({ 'lewis6991/impatient.nvim' }) -- Fast startup
        use({ 'onsails/lspkind-nvim' }) -- Icons for completion
        use({ 'szw/vim-maximizer', config = nnoremap({ '<leader>m', ':MaximizerToggle!<CR>' }) }) -- Maximize split
        use({ 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = 'markdown' }) -- Markdown preview
        use({ 'dstein64/vim-startuptime', config = conf('startuptime'), cmd = 'StartupTime' }) -- Measure startuptime
        use({ 'NTBBloodbath/rest.nvim', ft = 'http' }) -- HTTP requests
        use({ 'mbbill/undotree', cmd = 'UndotreeToggle' }) -- Undotree
        use({ 'tpope/vim-repeat' }) -- Reapat custom commands with .
        use({ 'tpope/vim-surround' }) -- Edit surrounds
        use({ 'lambdalisue/suda.vim' }) -- Write with sudo
        use({ 'tpope/vim-commentary' }) -- Easy commenting
        use({ 'tpope/vim-scriptease' }) -- Great commands
        use({ 'wellle/targets.vim' }) -- Fix some motions
    end,
    config = {
        profile = {
            enable = true,
        },
        display = {
            prompt_border = 'rounded',
        },
    },
})
