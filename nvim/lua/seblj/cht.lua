local M = {}
local ui = require('seblj.utils.ui')
local inoremap = vim.keymap.inoremap
local utils = require('seblj.utils')
local augroup = utils.augroup
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

local run_cht = function(selected)
    local query = vim.trim(vim.fn.getline('.'):sub(#'> ' + 1, -1))
    local input = vim.split(query, ' ')

    if vim.tbl_contains(languages, selected) then
        query = table.concat(input, '+')
    else
        query = table.concat(input, '~')
    end

    vim.api.nvim_win_close(0, true)
    vim.cmd('tabnew')
    run_term('curl cht.sh/' .. selected .. '/' .. query)
end

local input_query = function(selected)
    local lines = {}
    local title = 'Query'
    lines = { title, string.rep(ui.border_line, 30), unpack(lines) }
    local popup_bufnr, _ = ui.popup_create({
        lines = lines,
        width = 30,
        height = 3,
        enter = true,
        prompt = {
            enable = true,
            prefix = '> ',
            -- Highlight doesn't work with title title and border line.
            -- Probably an upstream error as there are other weird behaviours with prompt
            highlight = 'LspRenamePrompt',
        },
        on_confirm = function()
            run_cht(selected)
        end,
    })
    vim.api.nvim_buf_set_option(popup_bufnr, 'modifiable', true)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'Title', 0, 0, #title)
    vim.api.nvim_buf_add_highlight(popup_bufnr, -1, 'FloatBorder', 1, 0, -1)
    vim.cmd('norm! i')
end

local function confirm(prompt_bufnr)
    local content = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
    require('telescope.actions').close(prompt_bufnr)
    input_query(content.value)
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
