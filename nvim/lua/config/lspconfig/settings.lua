---------- LANGUAGE SERVERS ----------

return {
    volar = {
        init_options = {
            typescript = {
                serverPath = '/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js',
            },
        },
    },

    sumneko_lua = require('lua-dev').setup({
        library = {
            plugins = false,
        },
        lspconfig = {
            settings = {
                Lua = {
                    workspace = {
                        library = {
                            ['/Users/sebastianlyngjohansen/.hammerspoon/Spoons/EmmyLua.spoon/annotations'] = true,
                        },
                    },
                },
            },
        },
    }),

    jsonls = {
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
            },
        },
    },

    omnisharp = {
        handlers = {
            ['textDocument/definition'] = require('omnisharp_extended').handler,
        },
    },
}
