local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    component = fmt(
        [[
            <template>
            {tab}<div>

            {tab}</div>
            </template>

            <script setup lang="ts">
            {insert}
            </script>
        ]],
        {
            tab = f(function()
                return "\t"
            end),
            insert = i(0),
        }
    ),
})
