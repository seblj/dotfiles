local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    -- Template file
    new = fmt(
        [[
            #include <stdio.h>
            #include <stdlib.h>

            int main(int argc, char **argv) {{
            {tab}{insert}
            }}
        ]],
        {
            insert = i(0),
            tab = "\t",
        }
    ),
})
