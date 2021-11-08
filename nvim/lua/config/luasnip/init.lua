local ls = require('luasnip')

local snippets = {}

snippets.all = {}

snippets.go = require('config.luasnip.go')
snippets.typescriptreact = require('config.luasnip.react').typescriptreact
snippets.javascriptreact = require('config.luasnip.react').javascriptreact
snippets.lua = require('config.luasnip.lua')
snippets.c = require('config.luasnip.c')

ls.snippets = snippets