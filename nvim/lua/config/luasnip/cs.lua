local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return make({
    -- Template file
    printobject = fmt([[System.Console.WriteLine(JsonConvert.SerializeObject({insert}, Formatting.Indented));]], {
        insert = i(0),
    }),
})
