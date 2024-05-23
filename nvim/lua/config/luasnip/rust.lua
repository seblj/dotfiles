local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "modtest",
        fmt(
            [[
                #[cfg(test)]
                mod tests {{
                    use super::*;
                    {}
                }}
            ]],
            i(0)
        )
    ),

    s(
        "test",
        fmt(
            [[
                #[test]
                fn {}
            ]],
            i(0)
        )
    ),

    s(
        "tokio_test",
        fmt(
            [[
               #[tokio::test(flavor = "multi_thread")]
               async fn {}() -> Result<(), anyhow::Error> {{
                   {}
               }}
            ]],
            { i(1), i(0) }
        )
    ),

    s("derive", fmt("#[derive({})]", i(0))),
}
