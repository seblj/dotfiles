---------- TREESITTER CONFIG ----------

local treesitter_parsers = require('nvim-treesitter.parsers')
local utils = require('seblj.utils')

local ft_to_parser = treesitter_parsers.filetype_to_parsername
ft_to_parser.zsh = 'bash'

local parsers = treesitter_parsers.available_parsers()

local hlmap = vim.treesitter.highlighter.hl_map
hlmap.custom_type = 'TSCustomType'

local indent = {
    'tsx',
    'typescript',
    'vue',
    'javascript',
}

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'comment',
        'lua',
        'teal',
        'vim',
        'c',
        'c_sharp',
        'cpp',
        'make',
        'rust',
        'go',
        'gomod',
        'markdown',
        'python',
        'tsx',
        'javascript',
        'typescript',
        'vue',
        'html',
        'css',
        'scss',
        'graphql',
        'json',
        'yaml',
        'bibtex',
        'latex',
        'bash',
        'dockerfile',
        'http',
        'proto',
        'toml',
        'query',
    },

    highlight = {
        enable = true,
        disable = { 'help' },
    },
    indent = {
        enable = true,
        disable = utils.difference(parsers, indent),
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',

                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',

                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>sa'] = '@parameter.inner',
                ['<leader>sf'] = '@function.outer',
            },
            swap_previous = {
                ['<leader>sA'] = '@parameter.inner',
                ['<leader>sF'] = '@function.outer',
            },
        },
    },

    -- Comments
    context_commentstring = {
        enable = true,
        config = {
            rust = '// %s',
            c = '// %s',
            c_sharp = '// %s',
            python = '# %s',
        },
        custom_calculation = function(node, language_tree)
            local language_commentstrings = {
                c = { '// %s', '/* %s */' },
                c_sharp = { '// %s', '/* %s */' },
                tsx = { '// %s', '{/* %s */}' },
            }

            local parse_line = function(commentstring)
                local curr_line = vim.api.nvim_get_current_line()
                local first_char = vim.fn.match(curr_line, '\\S')

                local a = vim.split(commentstring, '%s', true)
                local first = a[1]:gsub('%s+', '')
                local second = a[2]:gsub('%s+', '')

                local start = string.sub(curr_line, first_char, first_char + #first):gsub('%s+', '')
                local last = string.sub(curr_line, 0 - #second, -1):gsub('%s+', '')

                if first == start and (second == last or #second == 0) then
                    return commentstring
                end
                return nil
            end

            local commentstrings = language_commentstrings[language_tree:lang()] or {}
            for _, commentstring in pairs(commentstrings) do
                local found = parse_line(commentstring)
                if found then
                    return found
                end
            end
        end,
    },

    autotag = {
        enable = true,
    },
})
