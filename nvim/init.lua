---------- INITIALIZE CONFIG ----------

require('options')
require('keymaps')

---------- PLUGINS ----------

local utils = require('utils')
local enable, disable, map = utils.enable, utils.disable, utils.map

local nvimlsp = disable
local coc = enable

vim.cmd [[packadd packer.nvim]]
vim.cmd [[autocmd BufWritePost init.lua PackerCompile]]

return require('packer').startup(function(use)
    use {'wbthomason/packer.nvim', opt = true}                          -- Package manager
    use {'norcalli/nvim-colorizer.lua',                                 -- Color highlighter
        config = [[require'colorizer'.setup()]]
    }
    use {'glepnir/dashboard-nvim',                                      -- Startup screen
        config = [[require'config/dashboard']]
    }
    use {'prettier/vim-prettier',                                       -- Formatting
        run = 'yarn install',
        config = map('n', '<leader>p', ':PrettierAsync<CR>')
    }
    use 'tpope/vim-repeat'                                              -- Reapat custom commands with .
    use {'puremourning/vimspector',                                     -- Debugging
        config = [[require'config/vimspector']]
    }
    use {'szw/vim-maximizer',                                           -- Maximize split
        config = map('n', '<leader>m', ':MaximizerToggle!<CR>')
    }
    use {'lewis6991/gitsigns.nvim',                                     -- Gitgutter alternative
        config = [[require'config/gitsigns']],
        branch = 'develop',
        cond = enable,
    }
    use {'tpope/vim-fugitive',
        config = [[require'config/fugitive']]
    }
    use {'glepnir/galaxyline.nvim',                                     -- Statusline
        branch = 'main',
        config = [[require'config/galaxyline']]
    }
    use {'neoclide/coc.nvim',                                           -- Lsp
        branch = 'release',
        config = [[require'config/coc']],
        cond = coc
    }
    use {'nvim-treesitter/nvim-treesitter',                             -- Parser tool syntax
        run = ':TSUpdate',
        config = [[require'config/treesitter']]
    }
    use 'nvim-treesitter/playground'                                    -- Display information from treesitter
    use {'neovim/nvim-lspconfig',                                       -- Built-in LSP
        config = [[require'config/lsp']],
        cond = nvimlsp
    }
    use {'nvim-lua/completion-nvim',                                    -- Built-in completion
        config = [[require'config/completion']],
        cond = nvimlsp
    }
    use {'steelsojka/completion-buffers',                               -- Buffer completion
        cond = nvimlsp
    }
    use {'kyazdani42/nvim-tree.lua',                                    -- Filetree in lua
        config = [[require'config/luatree']]
    }
    use 'kyazdani42/nvim-web-devicons'                                  -- Devicons in lua
    use {'nvim-telescope/telescope.nvim',                               -- Fuzzy finder
        requires = {'nvim-lua/popup.nvim',
                    'nvim-lua/plenary.nvim',
                    'nvim-telescope/telescope-fzy-native.nvim'},
        config = [[require'config/telescope']]
    }
    use 'lambdalisue/suda.vim'                                          -- Write with sudo
    use {'Raimondi/delimitMate',                                        -- Auto pairs
        config = [[vim.g.delimitMate_expand_cr = 1]]
    }
    use 'tpope/vim-commentary'                                          -- Easy commenting
    use 'terryma/vim-multiple-cursors'                                  -- Multiple cursors
    use 'tpope/vim-surround'                                            -- Edit surrounds
    use {'lervag/vimtex',                                               -- Latex
        config = [[require'config/vimtex']]
    }
    use {'alvan/vim-closetag',                                          -- Auto close HTML tags
        config = function()
            vim.g.closetag_filenames = '*.html,*.tsx'
            vim.g.closetag_regions = {typescriptreact = 'jsxRegion, tsxRegion'}
        end
    }
    use {'iamcco/markdown-preview.nvim',                                -- Markdown preview
        run = 'cd app && yarn install',
    }
end)


