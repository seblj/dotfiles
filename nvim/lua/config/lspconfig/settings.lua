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
            -- formatter.prettierd,
            formatter.stylua,
            formatter.eslint_d,
            formatter.goimports,
            diagnostics.eslint_d,
        },
    })
end

M.settings = {
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
            cmd = { 'lua-language-server' },
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
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    },
}

return M
