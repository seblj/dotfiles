local utils = require('seblj.utils')
local map = utils.map

Use_coc = true

-- Easy switch between nvimlsp and coc
local coc = function() return Use_coc end
local nvimlsp = function() return not Use_coc end

local plugin_dir = "~/projects/plugins/"

vim.cmd [[autocmd BufWritePost init.lua PackerCompile]]

return require('packer').startup(function(use)
    use {'wbthomason/packer.nvim'}                                      -- Package manager

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
            table.insert(use_tbl, string.format('%s/%s', username, plugin_name))
        end

        use (vim.tbl_extend('error', use_tbl, opts))
    end

    -- My plugins/forks
    local_use {'seblj/nvim-tabline',                                    -- Tabline
        config = [[require('tabline').setup{}]]
    }
    local_use {'seblj/nvim-echo-diagnostics',                           -- Echo lspconfig diagnostics
        config = [[require('echo-diagnostics').setup{}]],
        cond = nvimlsp
    }
    local_use {'windwp/nvim-autopairs',                                 -- Auto pairs
        config = [[require('config.autopairs')]],
        cond = function() return true end,
        upstream = true
    }
    local_use {'seblj/nvim-colorscheme'}

    -- Installed plugins
    use {'norcalli/nvim-colorizer.lua',                                 -- Color highlighter
        config = [[require('colorizer').setup()]],
    }
    use {'tjdevries/colorbuddy.nvim',
        config = [[require('colorbuddy').colorscheme('colorscheme')]]
    }
    use {'jbyuki/instant.nvim',                                         -- Live collaborating
        config = [[vim.g.instant_username = "seblj"]],
    }
    use {'glepnir/dashboard-nvim',                                      -- Startup screen
        config = [[require('config.dashboard')]]
    }
    use {'prettier/vim-prettier',                                       -- Formatting
        run = 'yarn install',
        config = [[require('config.prettier')]],
        cond = nvimlsp
    }
    use 'tpope/vim-repeat'                                              -- Reapat custom commands with .
    use {'puremourning/vimspector',                                     -- Debugging
        config = [[require('config.vimspector')]]
    }
    use {'szw/vim-maximizer',                                           -- Maximize split
        config = map('n', '<leader>m', ':MaximizerToggle!<CR>')
    }
    use {'lewis6991/gitsigns.nvim',                                     -- Git diff signs
        config = [[require('config.gitsigns')]],

    }
    use {'tpope/vim-fugitive',                                          -- Git-wrapper
        config = [[require('config.fugitive')]]
    }
    use {'glepnir/galaxyline.nvim',                                     -- Statusline
        branch = 'main',
        config = [[require('config.galaxyline')]]
    }
    use {'neoclide/coc.nvim',                                           -- LSP
        branch = 'release',
        config = [[require('config.coc')]],
        cond = coc
    }
    use {'nvim-treesitter/nvim-treesitter',                             -- Parser tool syntax
        run = ':TSUpdate',
        config = [[require('config.treesitter')]]
    }
    use 'nvim-treesitter/playground'                                    -- Display information from treesitter
    use {'neovim/nvim-lspconfig',                                       -- Built-in LSP
        config = [[require('config.lspconfig')]],
        cond = nvimlsp
    }
    use {'hrsh7th/nvim-compe',                                          -- Completion for nvimlsp
        config = [[require('config.compe')]],
        cond = nvimlsp
    }
    use {'glepnir/lspsaga.nvim',                                        -- UI for nvimlsp
        config = [[require('config.lspsaga')]],
        cond = nvimlsp
    }
    use {'onsails/lspkind-nvim',                                        -- Icons for completion
        config = nvimlsp
    }
    use {'kyazdani42/nvim-tree.lua',                                    -- Filetree
        config = [[require('config.luatree')]]
    }
    use 'kyazdani42/nvim-web-devicons'                                  -- Icons
    use {'nvim-telescope/telescope.nvim',                               -- Fuzzy finder
        requires = {'nvim-lua/popup.nvim',
                    'nvim-lua/plenary.nvim',
                    'nvim-telescope/telescope-fzy-native.nvim'},
        config = [[require('config.telescope')]]
    }

    -- Keep around and wait for references
    use {'fannheyward/telescope-coc.nvim',
        config = [[require('telescope').load_extension('coc')]],
        cond = function() return false end
    }
    use 'lambdalisue/suda.vim'                                          -- Write with sudo
    use {'Raimondi/delimitMate',                                        -- Auto pairs
        config = [[vim.g.delimitMate_expand_cr = 1]],
        cond = function() return false end
    }
    use {'preservim/nerdcommenter',                                     -- Easy commenting
       config = [[require('config.commentary')]]
    }
    use 'terryma/vim-multiple-cursors'                                  -- Multiple cursors
    use 'tpope/vim-surround'                                            -- Edit surrounds
    use {'lervag/vimtex',                                               -- Latex
        config = [[require('config.vimtex')]]
    }
    use {'iamcco/markdown-preview.nvim',                                -- Markdown preview
        run = 'cd app && yarn install',
    }
end)


