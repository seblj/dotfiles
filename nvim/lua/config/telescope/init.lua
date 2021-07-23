---------- TELESCOPE CONFIG ----------

local map = require('seblj.utils.keymap')
local nnoremap = map.nnoremap

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

nnoremap({ '<leader>ff', require('config.telescope.utils').find_files })
nnoremap({ '<leader>fg', require('config.telescope.utils').git_files })
nnoremap({ '<leader>fw', require('config.telescope.utils').live_grep })
nnoremap({ '<leader>fs', require('config.telescope.utils').grep_string })
nnoremap({ '<leader>fd', require('config.telescope.utils').edit_dotfiles })
nnoremap({ '<leader>fp', require('config.telescope.utils').installed_plugins })
nnoremap({ '<leader>fn', require('config.telescope.utils').search_neovim })
nnoremap({ '<leader>fk', require('telescope.builtin').keymaps })
nnoremap({ '<leader>fo', require('telescope.builtin').vim_options })
nnoremap({ '<leader>fe', require('telescope.builtin').file_browser })
nnoremap({ '<leader>fa', require('telescope.builtin').autocommands })
nnoremap({ '<leader>fh', require('telescope.builtin').help_tags })
nnoremap({ '<leader>fr', require('telescope.builtin').oldfiles })
