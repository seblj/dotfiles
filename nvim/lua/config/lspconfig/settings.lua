---------- LANGUAGE SERVERS ----------

local M = {}
local nls = require('null-ls')
local formatter = nls.builtins.formatting
local diagnostics = nls.builtins.diagnostics

M.nls_setup = function()
    nls.config({
        debounce = 150,
        save_after_format = false,
        sources = {
            formatter.prettierd,
            formatter.stylua,
            formatter.eslint_d,
            diagnostics.eslint,
        },
    })
end

M.settings = {
    vue = {
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

    lua = require('lua-dev').setup({
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

    python = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = 'off',
                },
            },
        },
    },

    cpp = {
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    },

    html = {
        filetypes = { 'html' },
    },
}

return M
