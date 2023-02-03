local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    ["function"] = fmt(
        [[
            function()
            {tab}{insert}
            end
        ]],
        { tab = "\t", insert = i(0) }
    ),
    ["then"] = fmt(
        [[
            then
            {tab}{insert}
            end
        ]],
        { tab = "\t", insert = i(0) }
    ),
    ["do"] = fmt(
        [[
            do
            {tab}{insert}
            end
        ]],
        { tab = "\t", insert = i(0) }
    ),
    headline = fmt([[---------- {insert} ----------]], {
        insert = i(0),
    }),
    ignore = {
        t({ "-- stylua: ignore" }),
    },
})
