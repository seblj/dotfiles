---------- LUASNIP ----------

local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, {
    desc = "Luasnip: Expand or jump",
})

vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, {
    desc = "Luasnip: Jump back",
})

vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, {
    desc = "Luasnip: Cycle through choice nodes",
})

local snippets = {}

snippets.all = {}

snippets.go = require("config.luasnip.go")
snippets.typescriptreact = require("config.luasnip.react").typescriptreact
snippets.javascriptreact = require("config.luasnip.react").javascriptreact
snippets.lua = require("config.luasnip.lua")
snippets.c = require("config.luasnip.c")
snippets.cs = require("config.luasnip.cs")
snippets.vue = require("config.luasnip.vue")
snippets.rust = require("config.luasnip.rust")

for lang, snips in pairs(snippets) do
    ls.add_snippets(lang, snips)
end
