---------- TREESITTER CONFIG ----------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local treesitter_parsers = require('nvim-treesitter.parsers')
local utils = require('seblj.utils')

local ft_to_parser = treesitter_parsers.filetype_to_parsername
ft_to_parser.zsh = 'bash'

vim.api.nvim_set_hl(0, '@custom_type', { link = 'TSCustomType' })

local indent = {
    'tsx',
    'typescript',
    'vue',
    'javascript',
}

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.rsx = {
    install_info = {
        url = 'https://github.com/seblj/tree-sitter-rsx',
        files = { 'src/parser.c', 'src/scanner.cc' },
        branch = 'comments',
    },
}

local read_file = function(path)
    local fd = assert(vim.loop.fs_open(path, 'r', 438))
    local stat = assert(vim.loop.fs_fstat(fd))
    return vim.loop.fs_read(fd, stat.size, 0)
end

local override_queries = function(lang, query_name)
    local queries_folder = vim.fs.normalize('~/dotfiles/nvim/lua/config/treesitter/queries')
    vim.treesitter.query.set_query(
        lang,
        query_name,
        read_file(queries_folder .. string.format('/%s/%s.scm', lang, query_name))
    )
end

autocmd('FileType', {
    pattern = 'rust',
    group = augroup('RustOverrideQuery', { clear = true }),
    callback = function()
        override_queries('rust', 'injections')
    end,
    desc = 'Override rust treesitter injection',
})

require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',

    highlight = {
        enable = true,
        disable = { 'help' },
    },
    indent = {
        enable = true,
        disable = utils.difference(treesitter_parsers.available_parsers(), indent),
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
            rsx = '// %s',
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
        filetypes = {
            'html',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'svelte',
            'vue',
            'tsx',
            'jsx',
            'rescript',
            'xml',
            'php',
            'markdown',
            'glimmer',
            'handlebars',
            'hbs',
            'htmldjango',
            'rust',
        },
    },
})
