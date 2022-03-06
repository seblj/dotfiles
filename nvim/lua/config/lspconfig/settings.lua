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

    grammarly = {
        filetypes = { 'tex', 'markdown' },
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

    pyright = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = 'off',
                },
            },
        },
    },

    omnisharp = {
        cmd = {
            '/Users/sebastianlyngjohansen/.local/omnisharp-osx/run',
            '--languageserver',
            '--hostPID',
            tostring(vim.fn.getpid()),
        },
    },
}
