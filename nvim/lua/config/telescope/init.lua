---------- TELESCOPE CONFIG ----------

local utils = require('seblj.utils')
local map = utils.map

require('telescope').setup({
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
    },
    extensions = {
        -- fzy_native = {
        --     override_file_sorter = true,
        --     override_generic_sorter = true,
        -- }
        fzf = {
            override_file_sorter = true,
            override_generic_sorter = true,
        },
    },
})
-- require('telescope').load_extension('fzy_native')
require('telescope').load_extension('fzf')

map('n', '<leader>ff', '<cmd>lua require("config.telescope.utils").find_files()<CR>')
map('n', '<leader>fg', '<cmd>lua require("config.telescope.utils").git_files()<CR>')
map('n', '<leader>fw', '<cmd>lua require("config.telescope.utils").live_grep()<CR>')
map('n', '<leader>fs', '<cmd>lua require("config.telescope.utils").grep_string()<CR>')
map('n', '<leader>fd', '<cmd>lua require("config.telescope.utils").edit_dotfiles()<CR>')
map('n', '<leader>fp', '<cmd>lua require("config.telescope.utils").installed_plugins()<CR>')
map('n', '<leader>fn', '<cmd>lua require("config.telescope.utils").search_neovim()<CR>')
map('n', '<leader>fk', '<cmd>lua require("telescope.builtin").keymaps()<CR>')
map('n', '<leader>fo', '<cmd>lua require("telescope.builtin").vim_options()<CR>')
map('n', '<leader>fe', '<cmd>lua require("telescope.builtin").file_browser()<CR>')
map('n', '<leader>fa', '<cmd>lua require("telescope.builtin").autocommands()<CR>')
map('n', '<leader>fht', '<cmd>lua require("telescope.builtin").help_tags()<CR>')
