---------- HANDLERS ----------

local M = {}

function M.handlers()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = CUSTOM_BORDER,
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = CUSTOM_BORDER,
    })
end

local function on_list_pick_or_jump(opts)
    ---@param res vim.lsp.LocationOpts.OnList
    return function(res)
        -- Filter out all items that that has the same line number and filename
        -- Don't need "duplicates" in the list
        local seen = {}
        local filtered_items = vim.iter(res.items)
            :map(function(item)
                local key = string.format("%s:%s", item.filename, item.lnum)
                if not seen[key] then
                    seen[key] = true
                    return item
                end
            end)
            :totable()

        if #filtered_items == 1 then
            return vim.lsp.util.show_document(filtered_items[1].user_data, "utf-8")
        end

        local conf = require("telescope.config").values
        require("telescope.pickers")
            .new(opts, {
                finder = require("telescope.finders").new_table({
                    results = filtered_items,
                    entry_maker = require("telescope.make_entry").gen_from_quickfix(opts),
                }),
                previewer = conf.qflist_previewer(opts),
                sorter = conf.generic_sorter(opts),
                push_cursor_on_edit = true,
                push_tagstack_on_edit = true,
            })
            :find()
    end
end

function M.references()
    local opts = { prompt_title = "LSP References" }
    vim.lsp.buf.references(nil, { on_list = on_list_pick_or_jump(opts) })
end

function M.defintions()
    local opts = { prompt_title = "LSP Definitions" }
    vim.lsp.buf.definition({ on_list = on_list_pick_or_jump(opts) })
end

return M
