---------- LANGUAGE SERVERS ----------

require('neodev').setup({
    library = {
        plugins = false,
    },
})

return {
    volar = {
        init_options = {
            typescript = {
                serverPath = '/usr/local/lib/node_modules/typescript/lib/tsserverlibrary.js',
            },
        },
    },

    rust_analyzer = {
        settings = {
            ['rust-analyzer'] = {
                rustfmt = {
                    extraArgs = { '+nightly' },
                },
            },
        },
    },

    sumneko_lua = {
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
