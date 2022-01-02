---------- TELESCOPE CONFIG ----------

local keymap = vim.keymap.set

require('telescope').setup({
    defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
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
keymap('n', '<leader>ff', function() require('config.telescope.utils').find_files() end)
keymap('n', '<leader>fg', function() require('config.telescope.utils').git_files() end)
keymap('n', '<leader>fw', function() require('config.telescope.utils').live_grep() end)
keymap('n', '<leader>fs', function() require('config.telescope.utils').grep_string() end)
keymap('n', '<leader>fd', function() require('config.telescope.utils').edit_dotfiles() end)
keymap('n', '<leader>fp', function() require('config.telescope.utils').installed_plugins() end)
keymap('n', '<leader>fn', function() require('config.telescope.utils').search_neovim() end)
keymap('n', '<leader>fe', function() require('telescope.builtin').file_browser() end)
keymap('n', '<leader>fo', function() require('telescope.builtin').oldfiles() end)
keymap('n', '<leader>fb', function() require('telescope.builtin').buffers() end)
keymap('n', '<leader>fk', function() require('telescope.builtin').keymaps() end)
keymap('n', '<leader>fa', function() require('telescope.builtin').autocommands() end)
keymap('n', '<leader>fh', function() require('telescope.builtin').help_tags() end)
keymap('n', '<leader>vo', function() require('telescope.builtin').vim_options() end)
keymap('n', '<leader>fq', function() require('seblj.cht').telescope_cht() end)
-- stylua: ignore end
