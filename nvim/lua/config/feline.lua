---------- STATUSLINE CONFIG ----------

if not pcall(require, 'feline') then
    return
end

local has = function(item)
    return vim.fn.has(item) == 1
end

-- Get wordcount in latex document. Only update the count on save
local latex_word_count = nil
local group = vim.api.nvim_create_augroup('UpdateWordCount', {})
vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = '*.tex',
    callback = function()
        latex_word_count = string.format('Words: %s', vim.fn['vimtex#misc#wordcount']())
    end,
})

local get_word_count = function()
    if not latex_word_count then
        latex_word_count = string.format('Words: %s', vim.fn['vimtex#misc#wordcount']())
    end
    return latex_word_count
end

local colors = {
    bg = '#303030',
    fg = '#8FBCBB',
    none = 'NONE',
    yellow = '#e7c664',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67',
}

local vi_mode_colors = {
    NORMAL = colors.green,
    INSERT = colors.red,
    VISUAL = colors.purple,
    OP = colors.green,
    BLOCK = colors.blue,
    REPLACE = colors.violet,
    ['V-REPLACE'] = colors.violet,
    ENTER = colors.cyan,
    MORE = colors.cyan,
    SELECT = colors.orange,
    COMMAND = colors.purple,
    SHELL = colors.green,
    TERM = colors.blue,
    NONE = colors.yellow,
}

local vi_mode_utils = require('feline.providers.vi_mode')

local components = {
    vi_mode = {
        provider = function()
            return vi_mode_utils.get_vim_mode() .. '  '
        end,
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
            }
        end,
        right_sep = ' ',
        left_sep = ' ',
    },
    file = {
        info = {
            provider = {
                name = 'file_info',
                opts = {
                    file_readonly_icon = ' ',
                    file_modified_icon = '',
                },
            },
            hl = { style = 'bold' },
        },
        type = {
            provider = 'file_type',
        },
        position = {
            provider = 'position',
            left_sep = {
                str = ' | ',
                hl = { fg = colors.blue },
            },
            right_sep = ' ',
        },
        percentage = {
            provider = 'line_percentage',
            hl = { style = 'bold' },
            left_sep = '  ',
            right_sep = ' ',
        },
    },
    diagnostics = {
        error = {
            provider = 'diagnostic_errors',
            icon = '  ',
            hl = { fg = colors.red },
        },
        warning = {
            provider = 'diagnostic_warnings',
            icon = '  ',
            hl = { fg = colors.orange },
        },
        hint = {
            provider = 'diagnostic_hints',
            icon = '  ',
            hl = { fg = colors.yellow },
        },
    },
    git = {
        branch = {
            provider = 'git_branch',
            icon = '  ',
            hl = { fg = colors.red, style = 'bold' },
        },
        add = {
            provider = 'git_diff_added',
            icon = '  ',
            hl = { fg = colors.green },
        },
        change = {
            provider = 'git_diff_changed',
            icon = '  ',
            hl = { fg = colors.blue },
        },
        remove = {
            provider = 'git_diff_removed',
            icon = '  ',
            hl = { fg = colors.red },
        },
    },
    os = {
        provider = function()
            if has('mac') then
                return ' '
            elseif has('linux') then
                return ' '
            end
        end,
        left_sep = '  ',
    },
    custom = {
        latex_words = {
            provider = function()
                return get_word_count()
            end,
            enabled = function()
                return vim.api.nvim_buf_get_option(0, 'ft') == 'tex'
            end,
        },
        buffer_type = {
            provider = function()
                local ft = vim.bo.filetype:upper()
                local fname = vim.fn.expand('%:t')
                local readonly, modified = '', ''
                if vim.bo.readonly then
                    readonly = ' '
                end
                if vim.bo.modified then
                    modified = ' '
                end
                local name = fname ~= '' and fname or ft
                return readonly .. name .. modified
            end,
            hl = { style = 'bold' },
        },
    },
}

local active = {
    {
        components.vi_mode,
        components.file.info,
        components.git.branch,
        components.git.add,
        components.git.change,
        components.git.remove,
    },
    {
        components.diagnostics.error,
        components.diagnostics.warning,
        components.diagnostics.hint,
        components.custom.latex_words,
        components.os,
        components.file.position,
        components.file.percentage,
    },
}

local inactive = {
    {
        components.custom.buffer_type,
    },
}

require('feline').setup({
    theme = { bg = colors.bg, fg = colors.fg },
    components = { active = active, inactive = inactive },
    vi_mode_colors = vi_mode_colors,
    force_inactive = {
        filetypes = {
            'packer',
            'NvimTree',
        },
    },
})
