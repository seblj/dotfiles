local utils = require('config.luasnip.utils')
local make = utils.make
local ls = require('luasnip')
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return make({
    testmod = fmt(
        [[
            #[cfg(test)]
            mod tests {{
                use super::*;
                {}
            }}
        ]],
        i(0)
    ),

    test = fmt(
        [[
            #[test]
            fn {}
        ]],
        i(0)
    ),

    derive = fmt(
        [[
            #[derive({})]
        ]],
        i(0)
    ),
})
