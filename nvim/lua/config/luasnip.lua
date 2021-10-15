local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local term = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local filename = function(_, _)
    return vim.fn.expand('%:t:r')
end

local tab = function(num_times)
    if not num_times then
        num_times = 1
    end
    return function(_, _)
        return term(string.rep('<Tab>', num_times))
    end
end

local snippets = {}

snippets.all = {}

snippets.lua = {
    -- Some lua snippets because the ones from LSP doesn't work
    s({ trig = 'function' }, {
        t({ 'function()', '' }),
        f(tab(), {}),
        i(0),
        t({ '', 'end' }),
    }),
    s({ trig = 'then' }, {
        t({ 'then', '' }),
        f(tab(), {}),
        i(0),
        t({ '', 'end' }),
    }),
    s({ trig = 'do' }, {
        t({ 'do', '' }),
        f(tab(), {}),
        i(0),
        t({ '', 'end' }),
    }),
    s({ trig = 'ignore' }, {
        t({ '-- stylua: ignore' }),
    }),
}

snippets.vue = {
    s('component', {
        t({ '<template>', '' }),
        f(tab(), {}),
        t({ '<div>', '', '' }),
        f(tab(), {}),
        t({
            '</div>',
            '</template>',
            '',
            '<script lang="ts">',
            '',
            "import { defineComponent } from 'vue';",
            '',
            'export default defineComponent({',
            '',
        }),
        f(tab(), {}),
        t({ "name: '" }),
        f(filename, {}),
        t({ "',", '', '' }),
        f(tab(), {}),
        t({ 'setup() {', '' }),
        f(tab(2), {}),
        i(0),
        t({ '', '' }),
        f(tab(), {}),
        t({
            '},',
            '});',
            '</script>',
            '',
            '<style lang="scss">',
            '',
            '</style>',
        }),
    }),
}

local react_component = s('component', {
    t({ "import React from 'react';", '', 'const ' }),
    f(filename, {}),
    t({ ' = () => {', '' }),
    f(tab(), {}),
    i(0),
    t({ '', '};', '', 'export default ' }),
    f(filename, {}),
    t({ ';' }),
})

snippets.typescriptreact = {
    react_component,
}

snippets.javascriptreact = {
    react_component,
}

ls.snippets = snippets
