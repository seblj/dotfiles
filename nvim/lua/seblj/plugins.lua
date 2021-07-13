local utils = require('seblj.utils')
local map = utils.map

Use_coc = false

local plugin_dir = '~/projects/plugins/'

vim.cmd([[autocmd BufWritePost init.lua PackerCompile]])

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
            config = [[require('tabline').setup{}]],
        })
        local_use({
            'seblj/nvim-echo-diagnostics', -- Echo lspconfig diagnostics
            config = [[require('echo-diagnostics').setup{}]],
            after = 'nvim-lspconfig',
            disable = Use_coc,
        })
        local_use({
            'seblj/nvim-xamarin', -- Build Xamarin from Neovim
            config = [[require('xamarin').setup{}]],
            force_local = true,
            disable = true,
        })

        -- Installed plugins
        -- Colors / UI
        use({
            'norcalli/nvim-colorizer.lua', -- Color highlighter
            config = [[require('colorizer').setup()]],
        })
        use({
            'mhinz/vim-startify', -- Startup screen
            config = [[require('config.startify')]],
        })
        use({
            'glepnir/galaxyline.nvim', -- Statusline
            config = [[require('config.galaxyline')]],
        })
        use('kyazdani42/nvim-web-devicons') -- Icons

        -- Git
        use({
            'lewis6991/gitsigns.nvim', -- Git diff signs
            event = { 'BufReadPre', 'BufWritePre' },
            config = [[require('config.gitsigns')]],
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
                vim.cmd('execute ":TSUpdate"')
            end,
            config = [[require('config.treesitter')]],
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
            disable = Use_coc,
            config = [[require('config.lspconfig')]],
        })
        use({ 'kabouzeid/nvim-lspinstall' }) -- Install language servers
        use({
            'L3MON4D3/LuaSnip',
            config = [[require('config.luasnip')]],
            event = 'InsertEnter',
        })
        use({
            'hrsh7th/nvim-compe', -- Completion for nvimlsp
            config = [[require('config.compe')]],
            event = 'InsertCharPre',
            commit = '3ba991f84fa6b3d3ecda072a2c6cf844de76c754',
            disable = Use_coc,
        })
        use({ 'ray-x/lsp_signature.nvim' })
        use({ 'onsails/lspkind-nvim' }) -- Icons for completion

        use({
            'neoclide/coc.nvim', -- LSP
            branch = 'release',
            config = [[require('config.coc')]],
            disable = not Use_coc,
        })

        -- Telescope
        use({
            'nvim-telescope/telescope.nvim', -- Fuzzy finder
            requires = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope-fzy-native.nvim',
            },
            config = [[require('config.telescope')]],
        })
        use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }) -- FZF algorithm for telescope
        use({
            'fannheyward/telescope-coc.nvim', -- Telescope extension for coc
            config = [[require('telescope').load_extension('coc')]],
            after = 'coc.nvim',
            disable = not Use_coc,
        })

        use({
            'mfussenegger/nvim-dap', -- Debugger
            config = [[require('config.dap')]],
            keys = '<leader>db',
        })
        use({
            'rcarriga/nvim-dap-ui', -- UI for debugger
            after = 'nvim-dap',
        })
        use({
            'szw/vim-maximizer', -- Maximize split
            config = map('n', '<leader>m', ':MaximizerToggle!<CR>'),
        })

        use({
            'vim-test/vim-test', -- Testing
            config = [[require('config.test')]],
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
            config = [[require('config.luatree')]],
            cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
            keys = { '<leader>tt' },
        })
        use({
            'tamago324/lir.nvim', -- File explorer
            config = [[require('config.fileexplorer')]],
        })

        use({ 'lambdalisue/suda.vim' }) -- Write with sudo
        use({ 'tpope/vim-commentary' }) -- Easy commenting
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
            config = [[require('config.autopairs')]],
            event = 'InsertEnter',
        })
        use('tpope/vim-surround') -- Edit surrounds
        use({ 'godlygeek/tabular' }) -- Line up text
        use('tpope/vim-repeat') -- Reapat custom commands with .
        use({
            'lervag/vimtex', -- Latex
            config = [[require('config.vimtex')]],
            ft = { 'tex', 'bib' },
        })
        use({ 'NTBBloodbath/rest.nvim', ft = 'http' }) -- HTTP requests
        use({
            'iamcco/markdown-preview.nvim', -- Markdown preview
            run = 'cd app && yarn install',
            ft = 'markdown',
        })
        -- use({
        --     'sbdchd/neoformat', -- Formatting
        --     config = [[require('config.formatter')]],
        -- })
        -- Messes with treesitter
        -- use({
        --     'prettier/vim-prettier', -- Formatting
        --     run = 'yarn install',
        --     config = [[require('config.prettier')]],
        -- })
    end,
    config = {
        display = {
            prompt_border = 'rounded',
        },
    },
})
