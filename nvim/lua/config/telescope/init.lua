---------- TELESCOPE CONFIG ----------

local keymap = vim.keymap.set
local action_layout = require('telescope.actions.layout')
local utils = require('config.telescope.utils')
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local cht = require('seblj.cht')
local extensions = telescope.extensions
local command = vim.api.nvim_create_user_command

telescope.setup({
    defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
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
require('telescope').load_extension('notify')

keymap('n', '<leader>ff', utils.find_files, { desc = 'Telescope: Find files' })
keymap('n', '<leader>fg', utils.git_files, { desc = 'Telescope: Git files' })
-- keymap('n', '<leader>fw', utils.live_grep, { desc = 'Telescope: Live grep' })
keymap('n', '<leader>fw', utils.multi_grep, { desc = 'Telescope: Live grep' })
keymap('n', '<leader>fs', utils.grep_string, { desc = 'Telescope: Grep string' })
keymap('n', '<leader>fd', utils.edit_dotfiles, { desc = 'Telescope: Dotfiles' })
keymap('n', '<leader>fp', utils.plugins, { desc = 'Telescope: Plugins' })
keymap('n', '<leader>fn', utils.search_neovim, { desc = 'Telescope: Neovim' })
keymap('n', '<leader>fe', extensions.file_browser.file_browser, { desc = 'Telescope: File Browser' })
keymap('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope: Oldfiles' })
keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope: Buffers' })
keymap('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope: Keymaps' })
keymap('n', '<leader>fa', builtin.autocommands, { desc = 'Telescope: Autocommands' })
keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: Helptags' })
keymap('n', '<leader>fc', builtin.command_history, { desc = 'Telescope: Command history' })
keymap('n', '<leader>vo', builtin.vim_options, { desc = 'Telescope: Vim options' })
keymap('n', '<leader>fq', cht.telescope_cht, { desc = 'curl cht.sh' })

command('NodeModules', utils.find_node_modules, { bang = true })
