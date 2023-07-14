local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    headline = fmt([[---------- {insert} ----------]], {
        insert = i(0),
    }),
    ignore = "-- stylua: ignore",
})
