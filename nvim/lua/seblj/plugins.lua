local utils = require('seblj.utils')
local enable, disable, map = utils.enable, utils.disable, utils.map

local nvimlsp = disable
local coc = enable

vim.cmd [[autocmd BufWritePost init.lua PackerCompile]]

return require('packer').startup(function(use)

    -- My plugins
    use {'~/projects/plugins/nvim-tabline',                             -- Tabline
        config = [[require('config.tabline')]]
    }

    -- Installed plugins
    use {'wbthomason/packer.nvim'}                                      -- Package manager
    use {'norcalli/nvim-colorizer.lua',                                 -- Color highlighter
        config = [[require('colorizer').setup()]]
    }
    use {'jbyuki/instant.nvim',                                         -- Live collaborating
        config = [[vim.g.instant_username = "seblyng"]]
    }
    use {'glepnir/dashboard-nvim',                                      -- Startup screen
        config = [[require('config.dashboard')]]
    }
    use {'prettier/vim-prettier',                                       -- Formatting
        run = 'yarn install',
        config = map('n', '<leader>p', ':PrettierAsync<CR>'),
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
        branch = 'main',
        cond = enable,
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
        config = [[require('config.lsp')]],
        cond = nvimlsp
    }
    use {'nvim-lua/completion-nvim',                                    -- Completion with built-in LSP
        config = [[require('config.completion')]],
        cond = nvimlsp
    }
    use {'steelsojka/completion-buffers',                               -- Buffer completion
        cond = nvimlsp
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
    use 'lambdalisue/suda.vim'                                          -- Write with sudo
    use {'Raimondi/delimitMate',                                        -- Auto pairs
        config = [[vim.g.delimitMate_expand_cr = 1]]
    }
    use 'tpope/vim-commentary'                                          -- Easy commenting
    use 'terryma/vim-multiple-cursors'                                  -- Multiple cursors
    use 'tpope/vim-surround'                                            -- Edit surrounds
    use {'lervag/vimtex',                                               -- Latex
        config = [[require('config.vimtex')]]
    }
    use {'iamcco/markdown-preview.nvim',                                -- Markdown preview
        run = 'cd app && yarn install',
    }
end)


