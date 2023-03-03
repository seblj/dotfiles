local M = {}

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

local total = vim.list_extend(languages, core_utils)

function M.telescope_cht()
    require("telescope.pickers")
        .new(require("telescope.themes").get_cursor(), {
            prompt_title = "Cheat sheet",
            finder = require("telescope.finders").new_table({
                results = total,
            }),
            attach_mappings = function(_, map)
                map({ "i", "n" }, "<CR>", function(bufnr)
                    local content = require("telescope.actions.state").get_selected_entry()
                    require("telescope.actions").close(bufnr)
                    vim.ui.input({ prompt = "Query: " }, function(query)
                        local input = vim.split(query, " ")
                        query = table.concat(input, vim.tbl_contains(languages, content.value) and "+" or "~")

                        require("seblj.utils").run_term({
                            direction = "tabnew",
                            focus = true,
                            stopinsert = true,
                            cmd = string.format("curl cht.sh/%s/%s", content.value, query),
                        })
                    end)
                end)
                return true
            end,
        })
        :find()
end

return M
