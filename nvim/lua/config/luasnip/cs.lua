local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    -- Template file
    printobject = fmt(
        [[System.Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject({insert}, Newtonsoft.Json.Formatting.Indented));]],
        {
            insert = i(0),
        }
    ),
})
