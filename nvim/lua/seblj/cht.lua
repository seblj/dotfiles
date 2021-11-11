local M = {}
local utils = require('seblj.utils')
local run_term = utils.run_term

local languages = {
    'golang',
    'typescript',
    'python',
    'lua',
    'c',
}

local core_utils = {
    'xargs',
    'find',
}

local telescope_selected = {}

local merge_lists = function(a, b)
    local list = {}
    list = a
    for _, v in pairs(b) do
        if not vim.tbl_contains(list, v) then
            table.insert(list, v)
        end
    end
    return list
end

local total = merge_lists(languages, core_utils)

local run_cht = function(query)
    local selected = telescope_selected[1]
    local input = vim.split(query, ' ')

    if vim.tbl_contains(languages, selected) then
        query = table.concat(input, '+')
    else
        query = table.concat(input, '~')
    end

    vim.cmd('tabnew')
    run_term('curl cht.sh/' .. selected .. '/' .. query)
end

local function confirm(prompt_bufnr)
    local content = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
    require('telescope.actions').close(prompt_bufnr)
    table.insert(telescope_selected, content.value)
    -- Schedule this so we can enter insert mode in the popup
    -- Assumen it is because telescope calls stopinsert after the callback has ended
    vim.schedule(function()
        vim.ui.input({ prompt = 'Query: ' }, run_cht)
    end)
end

M.telescope_cht = function()
    local opts = require('telescope.themes').get_cursor()
    require('telescope.pickers').new(opts, {
        prompt_title = 'Cheat sheet',
        finder = require('telescope.finders').new_table({
            results = vim.tbl_values(total),
        }),
        sorter = require('telescope.config').values.generic_sorter(opts),
        attach_mappings = function(_, map)
            map('i', '<CR>', confirm)
            map('n', '<CR>', confirm)
            return true
        end,
    }):find()
end

return M
