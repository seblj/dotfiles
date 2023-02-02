local utils = require("config.luasnip.utils")
local make = utils.make
local ls = require("luasnip")
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return make({
    modtest = fmt(
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

    tokio_test = fmt(
        [[
            #[tokio::test(flavor = "multi_thread")]
            async fn {}() -> Result<(), anyhow::Error> {{
                {}
            }}
        ]],
        {
            i(1),
            i(0),
        }
    ),

    derive = fmt(
        [[
            #[derive({})]
        ]],
        i(0)
    ),
})
