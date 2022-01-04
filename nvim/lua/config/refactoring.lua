local keymap = vim.keymap.set
require('refactoring').setup()

-- Confirm function when pressing enter in telescope
local function confirm(prompt_bufnr)
    local content = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
    require('telescope.actions').close(prompt_bufnr)
    -- Let telescope finish and do stopinsert before vim.ui.input
    -- is called, and startinsert is done there. If not, telescope
    -- will make the popup start in normal mode
    vim.schedule(function()
        require('refactoring').refactor(content.value)
    end)
end

-- Telescope picker to display refactor methods
local refactors = function()
    local opts = require('telescope.themes').get_cursor()
    require('telescope.pickers').new(opts, {
        prompt_title = 'Refactors',
        finder = require('telescope.finders').new_table({
            results = require('refactoring').get_refactors(),
        }),
        sorter = require('telescope.config').values.generic_sorter(opts),
        attach_mappings = function(_, map)
            map('i', '<CR>', confirm)
            map('n', '<CR>', confirm)
            return true
        end,
    }):find()
end

keymap('v', '<leader>fr', function()
    refactors()
end, { desc = 'Refactoring: Open menu' })
