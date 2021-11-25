local utils = require('config.luasnip.utils')
local make = utils.make
local filename = utils.filename
local ls = require('luasnip')
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

return make({
    component = fmt(
        [[
            <template>
            {tab}<div>

            {tab}<div>
            </template>

            <script lang="ts">

            import {{ defineComponent }} from 'vue';

            export default defineComponent({{
            {tab}name: '{filename}',
            {tab}{tab}{insert}
            {tab}}},
            }});
            </script>

            <style lang="scss">

            </style>
        ]],
        {
            tab = '\t',
            filename = f(filename, {}),
            insert = i(0),
        }
    ),
})
