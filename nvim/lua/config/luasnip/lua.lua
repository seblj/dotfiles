local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local i = ls.insert_node
local t = ls.text_node
local fmt = require('luasnip.extras.fmt').fmt

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
    headline = fmt([[---------- {insert} ----------]], {
        insert = i(0),
    }),
    ignore = {
        t({ '-- stylua: ignore' }),
    },
})
