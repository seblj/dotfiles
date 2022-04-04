local ls = require('luasnip')
local keymap = vim.keymap.set

keymap({ 'i', 's' }, '<C-j>', function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end)

keymap({ 'i', 's' }, '<C-k>', function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end)

local snippets = {}

snippets.all = {}

snippets.go = require('config.luasnip.go')
snippets.typescriptreact = require('config.luasnip.react').typescriptreact
snippets.javascriptreact = require('config.luasnip.react').javascriptreact
snippets.lua = require('config.luasnip.lua')
snippets.c = require('config.luasnip.c')
snippets.vue = require('config.luasnip.vue')
snippets.rust = require('config.luasnip.rust')

for lang, snips in pairs(snippets) do
    ls.add_snippets(lang, snips)
end
