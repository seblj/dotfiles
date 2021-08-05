---------- LANGUAGE SERVERS ----------

local M = {}
local Path = require('plenary.path')

local stylua_path = function()
    local path = vim.fn.findfile('stylua.toml', '.;')
    if path == '' then
        path = vim.fn.findfile('.stylua.toml', '.;')
        if path == '' then
            path = vim.fn.getenv('HOME') .. '/dotfiles/nvim/stylua.toml'
        end
    end
    return Path:new(path):absolute()
end

local eslint = {
    lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = { '%f:%l:%c: %m' },
    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
    formatStdin = true,
}

local stylua = {
    formatCommand = 'stylua --config-path ' .. stylua_path() .. ' -',
    formatStdin = true,
}

local prettier = {
    formatCommand = 'prettierd ${INPUT}',
    formatStdin = true,
}

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

    efm = {
        settings = {
            languages = {
                javascript = { prettier, eslint },
                javascriptreact = { prettier, eslint },
                typescript = { prettier, eslint },
                typescriptreact = { prettier, eslint },
                vue = { prettier, eslint },
                lua = { stylua },
            },
        },
        filetypes = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
            'lua',
        },
    },
}

return M
