local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    -- Template file
    printobject = fmt(
        [[
        System.Console.WriteLine(
            System.Text.Json.JsonSerializer.Serialize(
                {insert},
                new System.Text.Json.JsonSerializerOptions {{ WriteIndented = true }}
            )
        );
        ]],
        {
            insert = i(0),
        }
    ),
})
