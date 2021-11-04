local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local i = ls.insert_node
local t = ls.text_node
local d = ls.d
local snippet_from_nodes = ls.sn
local ts_locals = require('nvim-treesitter.locals')
local ts_utils = require('nvim-treesitter.ts_utils')

vim.treesitter.set_query(
    'go',
    'LuaSnip_Result',
    [[
  [
    (method_declaration result: (*) @id)
    (function_declaration result: (*) @id)
    (func_literal result: (*) @id)
  ]
]]
)

local transform = function(text)
    if text == 'int' then
        return t({ '0' })
    elseif text == 'error' then
        return t({ 'err' })
    elseif text == 'bool' then
        return t({ 'false' })
    elseif text == 'string' then
        return t({ '""' })
    elseif string.find(text, '*', 1, true) then
        return t({ 'nil' })
    end
    return t({ text })
end

local handlers = {
    ['parameter_list'] = function(node)
        local result = {}

        local count = node:named_child_count()
        for j = 0, count - 1 do
            table.insert(result, transform(vim.treesitter.get_node_text(node:named_child(j), 0)))
            if j ~= count - 1 then
                table.insert(result, t({ ', ' }))
            end
        end

        return result
    end,

    ['type_identifier'] = function(node)
        local text = vim.treesitter.get_node_text(node, 0)
        return { transform(text) }
    end,
}

local function go_result_type(info)
    local cursor_node = ts_utils.get_node_at_cursor()
    local scope = ts_locals.get_scope_tree(cursor_node, 0)

    local function_node
    for _, v in ipairs(scope) do
        if v:type() == 'function_declaration' or v:type() == 'method_declaration' or v:type() == 'func_literal' then
            function_node = v
            break
        end
    end

    local query = vim.treesitter.get_query('go', 'LuaSnip_Result')
    for _, node in query:iter_captures(function_node, 0) do
        if handlers[node:type()] then
            return handlers[node:type()](node, info)
        end
    end
    return {}
end

local go_ret_vals = function(_)
    local info = { index = 0, err_name = 'err' }
    return snippet_from_nodes(nil, go_result_type(info))
end

return make({
    -- Template file
    new = {
        t({ 'package main', '', 'func main() {', '\t' }),
        i(0),
        t({ '', '}' }),
    },

    ier = {
        t({ 'if err != nil {', '\treturn ' }),
        d(0, go_ret_vals, {}),
        t({ '', '}', '' }),
        i(0),
    },
})
