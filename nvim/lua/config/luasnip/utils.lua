local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node

local M = {}

function M.filename(_, _)
    return vim.fn.expand("%:t:r")
end

local function shortcut(val)
    if type(val) == "string" then
        return { t({ val }), i(0) }
    end

    if type(val) == "table" then
        for k, v in ipairs(val) do
            if type(v) == "string" then
                val[k] = t({ v })
            end
        end
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
