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
keymap('n', '<leader>ff', function() require('config.telescope.utils').find_files() end, { desc = 'Telescope: Find files' })
keymap('n', '<leader>fg', function() require('config.telescope.utils').git_files() end, { desc = 'Telescope: Git files' })
keymap('n', '<leader>fw', function() require('config.telescope.utils').live_grep() end, { desc = 'Telescope: Live grep' })
keymap('n', '<leader>fs', function() require('config.telescope.utils').grep_string() end, { desc = 'Telescope: Grep string' })
keymap('n', '<leader>fd', function() require('config.telescope.utils').edit_dotfiles() end, { desc = 'Telescope: Dotfiles' })
keymap('n', '<leader>fp', function() require('config.telescope.utils').installed_plugins() end, { desc = 'Telescope: Installed plugins' })
keymap('n', '<leader>fn', function() require('config.telescope.utils').search_neovim() end, { desc = 'Telescope: Neovim'})
keymap('n', '<leader>fe', function() require('telescope.builtin').file_browser() end, { desc = 'Telescope: File Browser' })
keymap('n', '<leader>fo', function() require('telescope.builtin').oldfiles() end, { desc = 'Telescope: Oldfiles' })
keymap('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Telescope: Buffers' })
keymap('n', '<leader>fk', function() require('telescope.builtin').keymaps() end, { desc = 'Telescope: Keymaps' })
keymap('n', '<leader>fa', function() require('telescope.builtin').autocommands() end, { desc = 'Telescope: Autocommands' })
keymap('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Telescope: Helptags' })
keymap('n', '<leader>vo', function() require('telescope.builtin').vim_options() end, { desc = 'Telescope: Vim options' })
keymap('n', '<leader>fq', function() require('seblj.cht').telescope_cht() end, { desc = 'curl cht.sh' })
-- stylua: ignore end
