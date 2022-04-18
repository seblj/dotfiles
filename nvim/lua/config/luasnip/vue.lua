local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return make({
    component = fmt(
        [[
            <template>
            {tab}<div>

            {tab}<div>
            </template>

            <script setup lang="ts">
            {insert}
            </script>

            <style lang="scss">

            </style>
        ]],
        {
            tab = '\t',
            insert = i(0),
        }
    ),
})
