local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "printobject",
        fmt(
            [[
                System.Console.WriteLine(
                    System.Text.Json.JsonSerializer.Serialize(
                        {},
                        new System.Text.Json.JsonSerializerOptions {{ WriteIndented = true }}
                    )
                );
            ]],
            { i(0) }
        )
    ),
}
