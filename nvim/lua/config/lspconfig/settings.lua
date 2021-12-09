---------- LANGUAGE SERVERS ----------

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

    pyright = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = 'off',
                },
            },
        },
    },

    clangd = {
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    },

    eslint = {
        filetypes = { 'vue', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
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
