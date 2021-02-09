---------- INITIALIZE CONFIG ----------

-- Load options
require('options')
require('keymaps')

-- Load plugins
require('plugins')

-- Load config for plugins
require('config/telescope')
require('config/treesitter')
require('config/vimspector')
require('config/coc')
require('config/vimtex')
require('config/gitsigns')
require('config/luatree')
require('config/galaxyline')

-- Not ready to use built-in LSP yet
-- require('config/lsp')
-- require('config/completion')

-- require('config/tags')
