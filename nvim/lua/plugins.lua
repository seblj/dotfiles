---------- PLUGINS ----------

vim.cmd [[packadd packer.nvim]]
vim.cmd [[ autocmd BufWritePost !silent plugins.lua PackerCompile ]]

return require('packer').startup(function()
    use {'wbthomason/packer.nvim', opt = true}
    -- use 'rafi/awesome-vim-colorschemes'                                 -- Colorschemes
    use {'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end}                                   -- Color highlighter
    use 'HerringtonDarkholme/yats.vim'                                  -- TypeScript syntax
    use 'MaxMEllon/vim-jsx-pretty'
    use 'tpope/vim-repeat'                                              -- Reapat custom commands with .
    use 'puremourning/vimspector'                                       -- Debugging
    use 'szw/vim-maximizer'                                             -- Maximize split
    use 'lewis6991/gitsigns.nvim'                                       -- Gitgutter alternative
    use {'glepnir/galaxyline.nvim', branch = 'main'}
    use {'neoclide/coc.nvim', branch = 'release'}                       -- LSP
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}          -- Parser tool syntax
    use 'nvim-treesitter/playground'                                    -- Display information from treesitter
    -- use 'neovim/nvim-lspconfig'                                         -- Built-in LSP
    -- use 'nvim-lua/completion-nvim'                                      -- Built-in completion
    -- use 'steelsojka/completion-buffers'                                 -- Buffer completion
    -- use 'ludovicchabant/vim-gutentags'                                  -- Tags for go-to definition
    use 'kyazdani42/nvim-tree.lua'                                      -- Filetree in lua
    use 'kyazdani42/nvim-web-devicons'                                  -- Devicons in lua
    use 'nvim-lua/popup.nvim'                                           -- Required for telescope
    use 'nvim-lua/plenary.nvim'                                         -- Required for telescope
    use 'nvim-telescope/telescope.nvim'                                 -- Fuzzy finder
    use 'lambdalisue/suda.vim'                                          -- Write with sudo
    use 'Raimondi/delimitMate'                                          -- Auto pairs
    use 'tpope/vim-commentary'                                          -- Easy commenting
    use 'terryma/vim-multiple-cursors'                                  -- Multiple cursors
    use 'tpope/vim-surround'                                            -- Edit surrounds
    use 'lervag/vimtex'                                                 -- Latex
    use 'alvan/vim-closetag'
    -- use 'JamshedVesuna/vim-markdown-preview'                            -- Markdown preview
end)
