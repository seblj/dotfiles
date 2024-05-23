local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s("headline", fmt("---------- {} ----------", { i(0) })),
    s("ignore", t("-- stylua: ignore")),
}
