---------- TELESCOPE CONFIG ----------

local utils = require('seblj.utils')
local map = utils.map

require('telescope').setup{
    defaults = {
        file_sorter =  require('telescope.sorters').get_fzy_sorter,
    },
    extensions = {
        fzy_native = {
            override_file_sorter = true,
            override_generic_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')

map('n', '<leader>ff', '<cmd>lua require("seblj.utils").find_files()<CR>')
map('n', '<leader>fg', '<cmd>lua require("seblj.utils").git_files()<CR>')
map('n', '<leader>fw', '<cmd>lua require("seblj.utils").live_grep()<CR>')
map('n', '<leader>fd', '<cmd>lua require("seblj.utils").edit_dotfiles()<CR>')
map('n', '<leader>fp', '<cmd>lua require("seblj.utils").installed_plugins()<CR>')
map('n', '<leader>fk', '<cmd>lua require("telescope.builtin").keymaps()<CR>')
map('n', '<leader>fo', '<cmd>lua require("telescope.builtin").vim_options()<CR>')
map('n', '<leader>fe', '<cmd>lua require("telescope.builtin").file_browser()<CR>')
