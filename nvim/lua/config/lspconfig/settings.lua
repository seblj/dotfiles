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
                dictionary = { ['en-US'] = ltex.lines_from(ltex.file.dictionary) },
                disabledRules = { ['en-US'] = ltex.lines_from(ltex.file.disabledRules) },
                hiddenFalsePositives = { ['en-US'] = ltex.lines_from(ltex.file.hiddenFalsePositives) },
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
