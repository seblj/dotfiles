---------- TELESCOPE CONFIG ----------

local nnoremap = vim.keymap.nnoremap

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

-- stylua: ignore start
nnoremap({ '<leader>ff', function() require('config.telescope.utils').find_files() end })
nnoremap({ '<leader>fg', function() require('config.telescope.utils').git_files() end })
nnoremap({ '<leader>fw', function() require('config.telescope.utils').live_grep() end })
nnoremap({ '<leader>fs', function() require('config.telescope.utils').grep_string() end })
nnoremap({ '<leader>fd', function() require('config.telescope.utils').edit_dotfiles() end })
nnoremap({ '<leader>fp', function() require('config.telescope.utils').installed_plugins() end })
nnoremap({ '<leader>fn', function() require('config.telescope.utils').search_neovim() end })
nnoremap({ '<leader>fk', function() require('telescope.builtin').keymaps() end })
nnoremap({ '<leader>fo', function() require('telescope.builtin').vim_options() end })
nnoremap({ '<leader>fe', function() require('telescope.builtin').file_browser() end })
nnoremap({ '<leader>fa', function() require('telescope.builtin').autocommands() end })
nnoremap({ '<leader>fh', function() require('telescope.builtin').help_tags() end })
nnoremap({ '<leader>fr', function() require('telescope.builtin').oldfiles() end })
-- stylua: ignore end
