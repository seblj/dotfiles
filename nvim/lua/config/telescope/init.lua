---------- TELESCOPE CONFIG ----------

local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap
local utils = require('config.telescope.utils')
local builtin = require('telescope.builtin')

require('telescope').setup({
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
    },
    extensions = {
        fzf = {
            override_file_sorter = true,
            override_generic_sorter = true,
        },
    },
})
require('telescope').load_extension('fzf')

nnoremap({ '<leader>ff', utils.find_files })
nnoremap({ '<leader>fg', utils.git_files })
nnoremap({ '<leader>fw', utils.live_grep })
nnoremap({ '<leader>fs', utils.grep_string })
nnoremap({ '<leader>fd', utils.edit_dotfiles })
nnoremap({ '<leader>fp', utils.installed_plugins })
nnoremap({ '<leader>fn', utils.search_neovim })
nnoremap({ '<leader>fk', builtin.keymaps })
nnoremap({ '<leader>fo', builtin.vim_options })
nnoremap({ '<leader>fe', builtin.file_browser })
nnoremap({ '<leader>fa', builtin.autocommands })
nnoremap({ '<leader>fh', builtin.help_tags })
nnoremap({ '<leader>fr', builtin.oldfiles })
