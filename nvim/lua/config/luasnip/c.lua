local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node

return make({
    -- Template file
    new = {
        t({
            '#include <stdio.h>',
            '#include <stdlib.h>',
            '',
            'int main(int argc, char **argv) {',
            '\t',
        }),
        i(0),
        t({ '', '}' }),
    },
})
