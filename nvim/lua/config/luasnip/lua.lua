local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local i = ls.insert_node
local t = ls.text_node

return make({
    ['function'] = {
        t({ 'function()', '' }),
        t({ '\t' }),
        i(0),
        t({ '', 'end' }),
    },
    ['then'] = {
        t({ 'then', '' }),
        t({ '\t' }),
        i(0),
        t({ '', 'end' }),
    },
    ['do'] = {
        t({ 'do', '' }),
        t({ '\t' }),
        i(0),
        t({ '', 'end' }),
    },
    ignore = {
        t({ '-- stylua: ignore' }),
    },
})
