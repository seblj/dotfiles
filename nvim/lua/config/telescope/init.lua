---------- TELESCOPE CONFIG ----------

return {
    config = function()
        require('telescope').setup({
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
                            require('telescope.actions.layout').cycle_layout_next(prompt_bufnr)
                        end,
                        ['<C-k>'] = function(prompt_bufnr)
                            require('telescope.actions.layout').cycle_layout_prev(prompt_bufnr)
                        end,
                    },
                },
            },
            extensions = {
                fzf = {
                    override_file_sorter = true,
                    override_generic_sorter = true,
                },
                file_browser = {
                    hidden = true,
                },
            },
        })

        require('telescope').load_extension('fzf')
        require('telescope').load_extension('file_browser')
        if pcall(require, 'notify') then
            require('telescope').load_extension('notify')
        end
    end,

    init = function()
        local map = function(mode, keys, module, func, desc)
            vim.keymap.set(mode, keys, function()
                if module == 'utils' then
                    require('config.telescope.utils')[func]()
                elseif module == 'builtin' then
                    require('telescope.builtin')[func]()
                end
            end, { desc = string.format('Telescope: %s', desc) })
        end

        map('n', '<leader>ff', 'utils', 'find_files', 'Find files')
        map('n', '<leader>fg', 'utils', 'git_files', 'Git files')
        map('n', '<leader>fw', 'utils', 'multi_grep', 'Live grep')
        map('n', '<leader>fs', 'utils', 'grep_string', 'Grep string')
        map('n', '<leader>fd', 'utils', 'edit_dotfiles', 'Dotfiles')
        map('n', '<leader>fp', 'utils', 'plugins', 'Plugins')
        map('n', '<leader>fn', 'utils', 'search_neovim', 'Neovim')

        map('n', '<leader>fo', 'builtin', 'oldfiles', 'Oldfiles')
        map('n', '<leader>fb', 'builtin', 'buffers', 'Buffers')
        map('n', '<leader>fk', 'builtin', 'keymaps', 'Keymaps')
        map('n', '<leader>fa', 'builtin', 'autocommands', 'Autocommands')
        map('n', '<leader>fh', 'builtin', 'help_tags', 'Helptags')
        map('n', '<leader>fc', 'builtin', 'command_history', 'Command history')
        map('n', '<leader>vo', 'builtin', 'vim_options', 'Vim options')

        vim.keymap.set('n', '<leader>fq', function()
            require('seblj.cht').telescope_cht()
        end, { desc = 'curl cht.sh' })

        vim.keymap.set('n', '<leader>fe', function()
            require('telescope').extensions.file_browser.file_browser()
        end, { desc = 'Telescope: File Browser' })

        vim.api.nvim_create_user_command('NodeModules', function()
            require('config.telescope.utils').find_node_modules()
        end, { bang = true })
    end,
}
