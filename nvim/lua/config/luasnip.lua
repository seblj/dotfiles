local imap = vim.keymap.imap

local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local term = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local snippets = {}

snippets.all = {}

snippets.lua = {
    -- Some lua snippets because the ones from LSP doesn't work
    s({ trig = 'function' }, {
        t({ 'function()', '    ' }),
        i(0),
        t({ '', 'end' }),
    }),
    s({ trig = 'then' }, {
        t({ 'then', '    ' }),
        i(0),
        t({ '', 'end' }),
    }),
    s({ trig = 'do' }, {
        t({ 'do', '    ' }),
        i(0),
        t({ '', 'end' }),
    }),
    s({ trig = 'ignore' }, {
        t({ '-- stylua: ignore' }),
    }),
}

snippets.vue = {
    -- Create component template for vue file
    s({ trig = 'component' }, {
        i(0),
        t({
            '<template>',
            '  <div>',
            '',
            '  </div>',
            '</template>',
            '',
            '<script lang="ts">',
            "import { defineComponent } from 'vue-demi';",
            '',
            'export default defineComponent({',
            '  setup() {',
            '',
            '  },',
            '});',
            '</script>',
            '',
            '<style lang="scss">',
            '',
            '</style>',
        }),
    }),
}

local filename = function(_, _)
    return vim.fn.expand('%:t:r')
end

local tab = function(_, _)
    return term('<Tab>')
end

local react_component = s('component', {
    t({ "import React from 'react';", '', '' }),
    t({ 'const ' }),
    f(filename, {}, ''),
    t({ ' = () => {', '' }),
    f(tab, {}, ''),
    i(0),
    t({ '', '};', '', '' }),
    t({ 'export default ' }),
    f(filename, {}, ''),
    t({ ';' }),
})

snippets.typescriptreact = {
    react_component,
}

snippets.javascriptreact = {
    react_component,
}

ls.snippets = snippets

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return term('<C-n>')
    elseif ls.expand_or_jumpable() then
        return term('<Plug>luasnip-expand-or-jump')
    else
        return term('<Tab>')
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return term('<C-p>')
    elseif ls.jumpable(-1) then
        return term('<Plug>luasnip-jump-prev')
    else
        return term('<S-Tab>')
    end
end

imap({ '<Tab>', 'v:lua.tab_complete()', expr = true })
imap({ '<S-Tab>', 'v:lua.s_tab_complete()', expr = true })
