local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node
local d = ls.d
local snippet_from_nodes = ls.sn
local fmt = require("luasnip.extras.fmt").fmt

local function transform(text)
    if text == "int" then
        return t({ "0" })
    elseif text == "error" then
        return t({ "err" })
    elseif text == "bool" then
        return t({ "false" })
    elseif text == "string" then
        return t({ '""' })
    elseif string.find(text, "*", 1, true) then
        return t({ "nil" })
    elseif string.find(text, "[]", 1, true) then
        return t({ "nil" })
    end
    return t({ text })
end

local handlers = {
    ["parameter_list"] = function(node)
        local result = {}
        local count = node:named_child_count()
        for j = 0, count - 1 do
            table.insert(result, transform(vim.treesitter.get_node_text(node:named_child(j), 0)))
            if j ~= count - 1 then
                table.insert(result, t({ ", " }))
            end
        end

        return result
    end,

    ["type_identifier"] = function(node)
        return { transform(vim.treesitter.get_node_text(node, 0)) }
    end,
}

local function go_result_type()
    local cursor_node = vim.treesitter.get_node()
    if not cursor_node then
        return {}
    end
    local scope = require("nvim-treesitter.locals").get_scope_tree(cursor_node, 0)

    for _, v in ipairs(scope) do
        if vim.tbl_contains({ "function_declaration", "method_declaration", "func_literal" }, v:type()) then
            local query = vim.treesitter.query.parse(
                "go",
                [[
                    [
                        (method_declaration result: (_) @id)
                        (function_declaration result: (_) @id)
                        (func_literal result: (_) @id)
                    ]
                ]]
            )
            for _, node in query:iter_captures(v, 0) do
                if handlers[node:type()] then
                    return handlers[node:type()](node)
                end
            end
        end
    end

    return {}
end

return make({
    -- Template file
    new = fmt(
        [[
            package main

            func main() {{
            {tab}{insert}
            }}
        ]],
        {
            insert = i(0),
            tab = "\t",
        }
    ),

    ier = fmt(
        [[
            if err != nil {{
            {tab}return {go_ret_vals}
            }}
            {insert}
        ]],
        {
            tab = "\t",
            go_ret_vals = d(1, function()
                return snippet_from_nodes(nil, go_result_type())
            end, {}),
            insert = i(0),
        }
    ),
})
