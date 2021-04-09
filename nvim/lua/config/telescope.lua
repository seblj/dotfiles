---------- TELESCOPE CONFIG ----------

local utils = require('utils')
local map = utils.map

require('telescope').setup{
    defaults = {
        file_sorter =  require('telescope.sorters').get_fzy_sorter,
    },
    extensions = {
        fzy_native = {
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')

map('n', '<leader>ff', ':update <bar> :lua require("utils").find_files()<CR>')
map('n', '<leader>fw', ':lua require("utils").live_grep()<CR>')
map('n', '<leader>fc', ':lua require("utils").find_cwd_files()<CR>')
map('n', '<leader>fd',':lua require("utils").edit_dotfiles()<CR>')
map('n', '<leader>fk', ':lua require("telescope.builtin").keymaps()<CR>')
map('n', '<leader>fo', ':lua require("telescope.builtin").vim_options()<CR>')
map('n', '<leader>fe', ':lua require("telescope.builtin").file_browser()<CR>')
map('n', '<C-t>', ':tabedit <bar> :lua require("utils").find_files()<CR>')