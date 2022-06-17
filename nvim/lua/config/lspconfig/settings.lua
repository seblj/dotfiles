---------- LANGUAGE SERVERS ----------

local ltex = require('config.lspconfig.ltex')

return {
    vuels = {
        init_options = {
            config = {
                vetur = {
                    completion = {
                        autoImport = true,
                        useScaffoldSnippets = false,
                    },
                },
            },
        },
    },

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

    -- TODO: See if I can get the grammarly lsp to work after the release of the new SDK
    grammarly = {
        init_options = {
            clientId = '10',
        },
    },

    ltex = {
        on_attach = function(client)
            ltex.on_attach(client)
        end,
        settings = {
            ltex = {
                language = 'en',
                dictionary = {},
                disabledRules = {},
                hiddenFalsePositives = {},
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue = 'en',
                    languageModel = '~/scratch/ngram',
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

    --     pyright = {
    --         settings = {
    --             python = {
    --                 analysis = {
    --                     typeCheckingMode = 'off',
    --                 },
    --             },
    --         },
    --     },
}
