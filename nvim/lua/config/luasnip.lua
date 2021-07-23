local map = require('seblj.utils.keymap')
local imap = map.imap

local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

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
}

snippets.vue = {
    -- Create template for SmartDok Vue file
    s({ trig = 'smartdok' }, {
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

ls.snippets = snippets

-- Map <Tab> and <S-Tab> to jump when not pumvisible
local term = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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
