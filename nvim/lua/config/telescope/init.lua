---------- TELESCOPE CONFIG ----------

local keymap = vim.keymap.set
local action_layout = require('telescope.actions.layout')
local utils = require('config.telescope.utils')
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local extensions = telescope.extensions

telescope.setup({
    defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        layout_strategy = 'flex',
        layout_config = {
            flex = {
                flip_columns = 120,
            },
        },
        mappings = {
            i = {
                ['<C-j>'] = function(prompt_bufnr)
                    action_layout.cycle_layout_next(prompt_bufnr)
                end,
                ['<C-k>'] = function(prompt_bufnr)
                    action_layout.cycle_layout_prev(prompt_bufnr)
                end,
            },
        },
    },
    extensions = {
        fzf = {
            override_file_sorter = true,
            override_generic_sorter = true,
        },
    },
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

-- stylua: ignore start
keymap('n', '<leader>ff', function() utils.find_files() end, { desc = 'Telescope: Find files' })
keymap('n', '<leader>fg', function() utils.git_files() end, { desc = 'Telescope: Git files' })
keymap('n', '<leader>fw', function() utils.live_grep() end, { desc = 'Telescope: Live grep' })
keymap('n', '<leader>fs', function() utils.grep_string() end, { desc = 'Telescope: Grep string' })
keymap('n', '<leader>fd', function() utils.edit_dotfiles() end, { desc = 'Telescope: Dotfiles' })
keymap('n', '<leader>fp', function() utils.plugins() end, { desc = 'Telescope: Plugins' })
keymap('n', '<leader>fn', function() utils.search_neovim() end, { desc = 'Telescope: Neovim'})
keymap('n', '<leader>fe', function() extensions.file_browser.file_browser() end, { desc = 'Telescope: File Browser' })
keymap('n', '<leader>fo', function() builtin.oldfiles() end, { desc = 'Telescope: Oldfiles' })
keymap('n', '<leader>fb', function() builtin.buffers() end, { desc = 'Telescope: Buffers' })
keymap('n', '<leader>fk', function() builtin.keymaps() end, { desc = 'Telescope: Keymaps' })
keymap('n', '<leader>fa', function() builtin.autocommands() end, { desc = 'Telescope: Autocommands' })
keymap('n', '<leader>fh', function() builtin.help_tags() end, { desc = 'Telescope: Helptags' })
keymap('n', '<leader>vo', function() builtin.vim_options() end, { desc = 'Telescope: Vim options' })
keymap('n', '<leader>fq', function() require('seblj.cht').telescope_cht() end, { desc = 'curl cht.sh' })
-- stylua: ignore end
