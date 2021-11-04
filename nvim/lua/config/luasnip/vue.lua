local utils = require('config.luasnip.utils')
local make = utils.make
local filename = utils.filename
local ls = require('luasnip')
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

return make({
    component = {
        t({
            '<template>',
            '\t<div>',
            '',
            '\t<div>',
            '</template>',
            '',
            '<script lang="ts">',
            '',
            "import { defineComponent } from 'vue';",
            '',
            'export default defineComponent({',
            "\tname: '",
        }),
        f(filename, {}),
        t({ "',", '', '\tsetup() {', '\t\t' }),
        i(0),
        t({
            '',
            '\t},',
            '});',
            '</script>',
            '',
            '<style lang="scss">',
            '',
            '</style>',
        }),
    },
})
