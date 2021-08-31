local augroup = require('seblj.utils').augroup
local nnoremap = vim.keymap.nnoremap

Use_coc = false

local plugin_dir = '~/projects/plugins/'

augroup('CompilePacker', {
    event = 'BufWritePost',
    pattern = 'plugins.lua',
    command = function()
        vim.cmd('PackerCompile')
    end,
})

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
        local_use({
            'seblj/nvim-tabline', -- Tabline
            config = function()
                require('tabline').setup({})
            end,
            event = 'TabNew',
        })
        local_use({
            'seblj/nvim-echo-diagnostics', -- Echo lspconfig diagnostics
            config = function()
                require('echo-diagnostics').setup({})
            end,
            after = 'nvim-lspconfig',
            disable = Use_coc,
        })
        local_use({
            'seblj/nvim-xamarin', -- Build Xamarin from Neovim
            config = function()
                require('xamarin').setup({})
            end,
            force_local = true,
            disable = true,
        })

        -- Installed plugins
        -- Colors / UI
        use({
            'norcalli/nvim-colorizer.lua', -- Color highlighter
            config = function()
                require('colorizer').setup()
            end,
        })
        use({
            'mhinz/vim-startify', -- Startup screen
            config = function()
                require('config.startify')
            end,
        })
        use({
            'glepnir/galaxyline.nvim', -- Statusline
            config = function()
                require('config.galaxyline')
            end,
        })
        use('kyazdani42/nvim-web-devicons') -- Icons

        -- Git
        use({
            'lewis6991/gitsigns.nvim', -- Git diff signs
            event = { 'BufReadPre', 'BufWritePre' },
            config = function()
                require('config.gitsigns')
            end,
        })
        use({
            'rhysd/conflict-marker.vim', -- Highlights for git conflict
            config = function()
                vim.g.conflict_marker_begin = '^<<<<<<< .*$'
                vim.g.conflict_marker_end = '^>>>>>>> .*$'
                vim.g.conflict_marker_enable_mappings = 0
            end,
            event = 'BufReadPre',
        })

        -- Treesitter
        use({
            'nvim-treesitter/nvim-treesitter', -- Parser tool syntax
            run = function()
                -- Post install hook to ensure maintained installed instead of in config
                -- Don't need to waste startuptime on ensuring installed on every start
                require('nvim-treesitter.install').ensure_installed('maintained')
                vim.cmd('TSUpdate')
            end,
            config = function()
                require('config.treesitter')
            end,
        })
        use({
            'nvim-treesitter/playground', -- Display information from treesitter
            after = 'nvim-treesitter',
        })
        use({
            'windwp/nvim-ts-autotag', -- Autotag using treesitter
            after = 'nvim-treesitter',
        })
        use({
            'nvim-treesitter/nvim-treesitter-textobjects', -- Manipulate text using treesitter
            after = 'nvim-treesitter',
        })
        use({
            'JoosepAlviste/nvim-ts-context-commentstring', -- Auto switch commentstring with treesitter
            after = 'nvim-treesitter',
        })

        -- LSP
        use({
            'neovim/nvim-lspconfig', -- Built-in LSP
            config = function()
                require('config.lspconfig')
            end,
            disable = Use_coc,
            requires = 'folke/lua-dev.nvim',
        })
        use({
            'jose-elias-alvarez/null-ls.nvim',
            disable = Use_coc,
        })
        use({
            'L3MON4D3/LuaSnip',
            config = function()
                require('config.luasnip')
            end,
            event = 'InsertEnter',
        })
        -- use({
        --     'hrsh7th/nvim-compe', -- Completion for nvimlsp
        --     config = function()
        --         require('config.compe')
        --     end,
        --     event = 'InsertCharPre',
        --     disable = Use_coc,
        -- })
        use({
            'hrsh7th/nvim-cmp', -- Completion
            config = function()
                require('config.cmp')
            end,
            requires = {
                { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
                { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
                { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
            },
            disable = Use_coc,
            event = 'InsertCharPre',
        })
        use({ 'onsails/lspkind-nvim' }) -- Icons for completion

        use({
            'neoclide/coc.nvim', -- LSP
            branch = 'release',
            config = function()
                require('config.coc')
            end,
            disable = not Use_coc,
        })

        use({ 'tjdevries/sg.nvim' })
        use({
            'ThePrimeagen/refactoring.nvim',
            config = function()
                require('config.refactoring')
            end,
            keys = '<leader>fr',
        })

        -- Telescope
        use({
            'nvim-telescope/telescope.nvim', -- Fuzzy finder
            requires = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
            },
            config = function()
                require('config.telescope')
            end,
        })
        use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }) -- FZF algorithm for telescope
        use({
            'fannheyward/telescope-coc.nvim', -- Telescope extension for coc
            config = function()
                require('telescope').load_extension('coc')
            end,
            after = 'coc.nvim',
            disable = not Use_coc,
        })

        use({
            'mfussenegger/nvim-dap', -- Debugger
            config = function()
                require('config.dap')
            end,
            keys = '<leader>db',
        })
        use({
            'rcarriga/nvim-dap-ui', -- UI for debugger
        })
        use({
            'szw/vim-maximizer', -- Maximize split
            config = nnoremap({ '<leader>m', ':MaximizerToggle!<CR>' }),
        })

        use({
            'vim-test/vim-test', -- Testing
            config = function()
                require('config.test')
            end,
            cmd = { 'TestFile', 'TestNearest', 'TestLast' },
        })
        use({
            'rcarriga/vim-ultest', -- Testing UI
            run = ':UpdateRemotePlugins',
            cond = function()
                return false
            end,
        })

        use({
            'kyazdani42/nvim-tree.lua', -- Filetree
            config = function()
                require('config.luatree')
            end,
            cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
            keys = { '<leader>tt' },
        })
        use({
            'tamago324/lir.nvim', -- File explorer
            config = function()
                require('config.fileexplorer')
            end,
        })

        use({ 'lambdalisue/suda.vim' }) -- Write with sudo
        use({ 'tpope/vim-commentary' }) -- Easy commenting
        use({
            'tpope/vim-scriptease',
            cmd = {
                'Messages', --view messages in quickfix list
                'Verbose', -- view verbose output in preview window.
                'Time', -- measure how long it takes to run some stuff.
            },
        })
        use({
            'dstein64/vim-startuptime', -- Measure startuptime
            config = function()
                vim.g.startuptime_more_info_key_seq = 'i'
                vim.g.startuptime_split_edit_key_seq = ''
            end,
            cmd = 'StartupTime',
        })
        use({
            'windwp/nvim-autopairs', -- Auto pairs
            config = function()
                require('config.autopairs')
            end,
            event = 'InsertEnter',
        })
        use('tpope/vim-surround') -- Edit surrounds
        use({
            'godlygeek/tabular',
            config = function()
                vim.g.no_default_tabular_maps = 1
            end,
        }) -- Line up text
        use({
            'vuki656/package-info.nvim',
            config = function()
                require('package-info').setup()
            end,
            ft = 'json',
        })
        use('tpope/vim-repeat') -- Reapat custom commands with .
        use({
            'lervag/vimtex', -- Latex
            config = function()
                require('config.vimtex')
            end,
            ft = { 'tex', 'bib' },
        })
        use({ 'NTBBloodbath/rest.nvim', ft = 'http' }) -- HTTP requests
        use({
            'iamcco/markdown-preview.nvim', -- Markdown preview
            run = 'cd app && yarn install',
            ft = 'markdown',
        })
        use({ 'mbbill/undotree', cmd = 'UndotreeToggle' })
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
