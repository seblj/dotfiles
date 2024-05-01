local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node

local M = {}

local function shortcut(val)
    if type(val) == "string" then
        return { t({ val }), i(0) }
    end

    if type(val) == "table" then
        return vim.iter(val)
            :map(function(v)
                return type(v) == "string" and t({ v }) or v
            end)
            :totable()
    end

    return val
end

-- Borrow from tj for how to make a snippet
-- Looks more clean with the trigger as a key in a table than a string in a snippenode imo
function M.make(tbl)
    return vim.iter(pairs(tbl))
        :map(function(k, v)
            return ls.s({ trig = k, desc = v.desc }, shortcut(v))
        end)
        :totable()
end

return M
