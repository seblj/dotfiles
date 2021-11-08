---------- TREESITTER CONFIG ----------

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        disable = { 'latex' },
    },
})

local hlmap = vim.treesitter.highlighter.hl_map
hlmap.custom_type = 'TSCustomType'

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
parser_configs.http = {
    install_info = {
        url = 'https://github.com/NTBBloodbath/tree-sitter-http',
        files = { 'src/parser.c' },
        branch = 'main',
    },
}

require('nvim-treesitter.configs').setup({
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
    },

    autotag = {
        enable = true,
    },
})

local context_commentstring = require('ts_context_commentstring.internal')
local utils = require('ts_context_commentstring.utils')

local language_commentstrings = {
    c = { '//%s', '/*%s*/' },
}

local parse_line = function(commentstring)
    local a = vim.split(commentstring, '%s', true)
    local current_line = vim.fn.getline('.')
    local first_non_whitespace_col = vim.fn.match(vim.fn.getline('.'), '\\S')

    local first = a[1]:gsub('%s+', '')
    local second = a[2]:gsub('%s+', '')
    local start = string.sub(current_line, first_non_whitespace_col, first_non_whitespace_col + #first):gsub('%s+', '')
    local last = string.sub(current_line, 0 - #second, -1):gsub('%s+', '')

    if first == start then
        if second == last or #second == 0 then
            return commentstring
        end
    end
    return nil
end

local find_commentstring_under_cursor = function()
    local node, language_tree = utils.get_node_at_cursor_start_of_line(vim.tbl_keys(context_commentstring.config))

    if not node and not language_tree then
        return nil
    end

    -- Only continue if uncommenting
    if node:type() ~= 'comment' then
        return nil
    end

    -- Find current language and possible commentstrings for the language based on config
    local commentstrings = language_commentstrings[language_tree:lang()]

    -- No config for commentstrings so use default
    if not commentstrings then
        return nil
    end

    for _, commentstring in pairs(commentstrings) do
        local found = parse_line(commentstring)
        if found then
            return found
        end
    end

    return nil
end

-- Override update_commenstring from nvim-ts-context-commentstring
context_commentstring.update_commentstring = function()
    local found_commentstring = context_commentstring.calculate_commentstring()
    local existing_commentstring = find_commentstring_under_cursor()

    if existing_commentstring then
        found_commentstring = existing_commentstring
    end

    if found_commentstring then
        vim.api.nvim_buf_set_option(0, 'commentstring', found_commentstring)
    else
        -- No commentstring was found, default to the
        if vim.b.ts_original_commentstring then
            vim.api.nvim_buf_set_option(0, 'commentstring', vim.b.ts_original_commentstring)
        end
    end
end
