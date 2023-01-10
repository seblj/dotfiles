local M = {}
local utils = require("seblj.utils")
local run_term = utils.run_term

local languages = {
    "golang",
    "typescript",
    "python",
    "lua",
    "c",
    "rust",
}

local core_utils = {
    "xargs",
    "find",
}

local telescope_selected = {}

local total = utils.union(languages, core_utils)

local function run_cht(query)
    local selected = telescope_selected[1]
    local input = vim.split(query, " ")

    if vim.tbl_contains(languages, selected) then
        query = table.concat(input, "+")
    else
        query = table.concat(input, "~")
    end

    run_term({
        direction = "tabnew",
        focus = true,
        stopinsert = true,
        cmd = string.format("curl cht.sh/%s/%s", selected, query),
    })
end

local function confirm(prompt_bufnr)
    local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
    require("telescope.actions").close(prompt_bufnr)
    table.insert(telescope_selected, content.value)
    vim.ui.input({ prompt = "Query: " }, run_cht)
end

function M.telescope_cht()
    local opts = require("telescope.themes").get_cursor()
    require("telescope.pickers")
        .new(opts, {
            prompt_title = "Cheat sheet",
            finder = require("telescope.finders").new_table({
                results = vim.tbl_values(total),
            }),
            sorter = require("telescope.config").values.generic_sorter(opts),
            attach_mappings = function(_, map)
                map("i", "<CR>", confirm)
                map("n", "<CR>", confirm)
                return true
            end,
        })
        :find()
end

return M
