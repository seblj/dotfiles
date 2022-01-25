---------- TREESITTER CONFIG ----------

-- Hack to enable bash parser for zsh
local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
require('nvim-treesitter.parsers').ft_to_lang = function(ft)
    if ft == 'zsh' then
        return 'bash'
    end
    return ft_to_lang(ft)
end

local hlmap = vim.treesitter.highlighter.hl_map
hlmap.custom_type = 'TSCustomType'

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        ensure_installed = 'maintained',
        disable = { 'latex' },
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
        },
        custom_calculation = function(node, language_tree)
            local language_commentstrings = {
                c = { '//%s', '/*%s*/' },
                tsx = { '//%s', '{/*%s*/}' },
            }

            local parse_line = function(commentstring)
                local a = vim.split(commentstring, '%s', true)
                local current_line = vim.fn.getline('.')
                local first_non_whitespace_col = vim.fn.match(vim.fn.getline('.'), '\\S')

                local first = a[1]:gsub('%s+', '')
                local second = a[2]:gsub('%s+', '')
                local start =
                    string.sub(current_line, first_non_whitespace_col, first_non_whitespace_col + #first):gsub(
                        '%s+',
                        ''
                    )
                local last = string.sub(current_line, 0 - #second, -1):gsub('%s+', '')

                if first == start then
                    if second == last or #second == 0 then
                        return commentstring
                    end
                end
                return nil
            end

            local commenstrings = language_commentstrings[language_tree:lang()] or {}
            for _, commentstring in pairs(commenstrings) do
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
