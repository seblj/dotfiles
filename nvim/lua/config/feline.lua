---------- STATUSLINE CONFIG ----------

local ok_feline, feline = pcall(require, 'feline')
if not ok_feline then
    return
end

local has = function(item)
    return vim.fn.has(item) == 1
end

local get_color = function(group, attr)
    local color = vim.fn.synIDattr(vim.fn.hlID(group), attr)
    return color ~= '' and color or nil
end

-- Get wordcount in latex document. Only update the count on save
local latex_word_count = nil
local augroup = vim.api.nvim_create_augroup('UpdateWordCount', {})
vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    pattern = '*.tex',
    callback = function()
        latex_word_count = string.format(' Words: %s', vim.fn['vimtex#misc#wordcount']())
    end,
    desc = 'Update word count in latex',
})

local get_word_count = function()
    if not latex_word_count then
        latex_word_count = string.format(' Words: %s', vim.fn['vimtex#misc#wordcount']())
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
                return vim.bo.filetype == 'tex'
            end,
        },
        buffer_type = {
            provider = function()
                local ft = vim.bo.filetype:upper()
                local bufname = vim.api.nvim_buf_get_name(0)
                local fname = vim.fn.fnamemodify(bufname, ':t')
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

feline.setup({
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

---------- WINBAR ----------

local icons = require('seblj.utils.icons')
local ok_gps, nvim_gps = pcall(require, 'nvim-gps')

if ok_gps then
    local setup_icons = function(group, icon)
        return '%#' .. group .. '#' .. icon .. '%*' .. ' '
    end
    nvim_gps.setup({
        icons = {
            ['class-name'] = setup_icons('Keyword', icons.kind.Class),
            ['function-name'] = setup_icons('Function', icons.kind.Function),
            ['method-name'] = setup_icons('Function', icons.kind.Method),
            ['container-name'] = setup_icons('CmpItemKindColor', icons.kind.Object),
            ['tag-name'] = setup_icons('TSTag', icons.misc.Tag),
            ['mapping-name'] = setup_icons('CmpItemKindColor', icons.kind.Object),
            ['sequence-name'] = setup_icons('CmpItemKindProperty', icons.kind.Array),
            ['null-name'] = setup_icons('CmpItemKindField', icons.kind.Field),
            ['boolean-name'] = setup_icons('Boolean', icons.kind.Boolean),
            ['integer-name'] = setup_icons('Number', icons.kind.Number),
            ['float-name'] = setup_icons('Float', icons.kind.Number),
            ['string-name'] = setup_icons('String', icons.kind.String),
            ['array-name'] = setup_icons('CmpItemKindProperty', icons.kind.Array),
            ['object-name'] = setup_icons('CmpItemKindColor', icons.kind.Object),
            ['number-name'] = setup_icons('Number', icons.kind.Number),
            ['table-name'] = setup_icons('CmpItemKindProperty', icons.ui.Table),
            ['date-name'] = setup_icons('CmpItemKindValue', icons.ui.Calendar),
            ['date-time-name'] = setup_icons('CmpItemKindValue', icons.ui.Table),
            ['inline-table-name'] = setup_icons('CmpItemKindProperty', icons.ui.Calendar),
            ['time-name'] = setup_icons('CmpItemKindValue', icons.misc.Watch),
            ['module-name'] = setup_icons('CmpItemKindModule', icons.kind.Module),
            ['title-name'] = setup_icons('Title', '#'),
            ['label-name'] = setup_icons('String', icons.kind.String),
            ['hook-name'] = setup_icons('Function', 'ﯠ'),
        },
        languages = {
            json = {},
            yaml = {},
            latex = {},
            tsx = {},
        },
        separator = '  ',
    })
end

local winbar_components = {
    maximized = {
        provider = function()
            return 'Maximized'
        end,
        enabled = function()
            return vim.t.maximized
        end,
    },
    file = {
        provider = {
            name = 'file_info',
            opts = {
                file_readonly_icon = ' ',
                file_modified_icon = '',
            },
        },
        left_sep = {
            str = ' ',
            hl = { bg = get_color('Normal', 'bg') },
        },
        hl = { bg = get_color('Normal', 'bg'), style = 'bold' },
        enabled = function()
            return vim.api.nvim_buf_get_name(0) ~= ''
        end,
    },
    filetype = {
        provider = 'file_type',
        enabled = function()
            return vim.api.nvim_buf_get_name(0) == ''
        end,
    },
    gps = {
        provider = function()
            local location = nvim_gps.get_location()
            return location == '' and '' or '  ' .. location
        end,
        enabled = function()
            return ok_gps and nvim_gps.is_available()
        end,
        hl = { fb = get_color('Normal', 'fg') },
    },
}

local winbar = {
    {
        winbar_components.maximized,
        winbar_components.file,
        winbar_components.filetype,
        winbar_components.gps,
    },
}

-- Have winbar background to be the same as Normal
for _, val in pairs(winbar) do
    for _, component in pairs(val) do
        if not component.hl then
            component.hl = { bg = get_color('Normal', 'bg') }
        end
        if not component.hl.bg then
            component.hl.bg = get_color('Normal', 'bg')
        end
    end
end

local blocked_fts = {
    'term',
    'startify',
    'NvimTree',
    'packer',
    'startuptime',
}

feline.winbar.setup({
    theme = { bg = get_color('Normal', 'bg') },
    components = { active = winbar, inactive = winbar },
    disable = {
        filetypes = blocked_fts,
    },
})

-- Hack to not enable winbar on all buffers
local winbar_group = vim.api.nvim_create_augroup('AttachWinbar', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'TabNew', 'TabEnter', 'BufEnter', 'WinClosed', 'BufWritePost' }, {
    group = winbar_group,
    desc = 'Winbar only on some buffers',
    callback = function()
        vim.o.winbar = ''
        for _, w in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf, win = vim.bo[vim.api.nvim_win_get_buf(w)], vim.wo[w]
            if
                not vim.tbl_contains(blocked_fts, buf.filetype)
                and vim.fn.win_gettype(vim.api.nvim_win_get_number(w)) == ''
                and buf.buftype == ''
                and buf.filetype ~= ''
                and not win.diff
            then
                win.winbar = "%{%v:lua.require'feline'.generate_winbar()%}"
            elseif win.diff then
                win.winbar = nil
            end
        end
    end,
})
