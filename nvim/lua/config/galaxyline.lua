---------- STATUSLINE CONFIG ----------

local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {
    'NvimTree',
    'packer',
}

local colors = {
    bg = '#282c34',
    line_bg = '#303030',
    fg = '#8FBCBB',
    fg_green = '#65a380',
    none = 'NONE',
    yellow = '#e7c664',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#c678dd',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67',
}

local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
        return true
    end
    return false
end

local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
    end
    return false
end

---------- LEFT ----------

gls.left[1] = {
    ViMode = {
        provider = function()
            -- auto change color according the vim mode
            local alias = {
                n = 'NORMAL',
                i = 'INSERT',
                V = 'VISUAL',
                [''] = 'VISUAL',
                v = 'VISUAL',
                c = 'COMMAND-LINE',
                ['r?'] = ':CONFIRM',
                rm = '--MORE',
                R = 'REPLACE',
                Rv = 'VIRTUAL',
                s = 'SELECT',
                S = 'SELECT',
                ['r'] = 'HIT-ENTER',
                [''] = 'SELECT',
                t = 'TERMINAL',
                ['!'] = 'SHELL',
            }
            local mode_color = {
                n = colors.green,
                i = colors.red,
                c = colors.purple,
                v = colors.blue,
                [''] = colors.blue,
                V = colors.blue,
                no = colors.magenta,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                cv = colors.red,
                ce = colors.red,
                ['r?'] = colors.cyan,
                ['!'] = colors.green,
                t = colors.blue,
                ['r'] = colors.red,
                rm = colors.red,
                R = colors.yellow,
                Rv = colors.magenta,
            }
            local vim_mode = vim.fn.mode()
            vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim_mode])
            return '  ' .. alias[vim_mode] .. '   '
        end,
        highlight = { colors.red, colors.line_bg, 'bold' },
    },
}
gls.left[2] = {
    FileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.line_bg },
    },
}
gls.left[3] = {
    FileName = {
        provider = { 'FileName' },
        condition = buffer_not_empty,
        highlight = { colors.fg, colors.line_bg, 'bold' },
    },
}

gls.left[4] = {
    GitIcon = {
        provider = function()
            return '  '
        end,
        condition = require('galaxyline.provider_vcs').get_git_branch,
        highlight = { colors.red, colors.line_bg, 'bold' },
    },
}
gls.left[5] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = require('galaxyline.provider_vcs').get_git_branch,
        highlight = { colors.red, colors.line_bg, 'bold' },
        separator = ' ',
        separator_highlight = { colors.bg, colors.line_bg },
    },
}

gls.left[6] = {
    DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = ' ',
        -- icon = '  ',
        highlight = { colors.green, colors.line_bg },
    },
}
gls.left[7] = {
    DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = ' ',
        -- icon = ' 柳',
        highlight = { colors.blue, colors.line_bg },
    },
}
gls.left[8] = {
    DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = ' ',
        -- icon = '  ',
        highlight = { colors.red, colors.line_bg },
    },
}

---------- RIGHT ----------

gls.right[1] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = { colors.red, colors.line_bg },
    },
}

gls.right[2] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = { colors.orange, colors.line_bg },
    },
}
-- Info in coc is the same as hint for nvim lspconfig
gls.right[3] = {
    DiagnosticInfo = { -- Show info for coc
        provider = 'DiagnosticInfo',
        condition = function()
            return Use_coc
        end,
        icon = '  ',
        highlight = { colors.yellow, colors.line_bg },
    },
}
gls.right[3] = { -- Show hint for nvim lspconfig
    DiagnosticHint = {
        provider = 'DiagnosticHint',
        condition = function()
            return not Use_coc
        end,
        icon = '  ',
        highlight = { colors.yellow, colors.line_bg },
    },
}

gls.right[4] = {
    FileFormat = {
        provider = 'FileFormat',
        separator = ' ',
        separator_highlight = { colors.bg, colors.line_bg },
        highlight = { colors.fg, colors.line_bg, 'bold' },
    },
}

gls.right[5] = {
    LineInfo = {
        provider = 'LineColumn',
        separator = ' | ',
        separator_highlight = { colors.blue, colors.line_bg },
        highlight = { colors.fg, colors.line_bg },
    },
}
gls.right[6] = {
    PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = { colors.line_bg, colors.line_bg },
        highlight = { colors.fg, colors.line_bg, 'bold' },
    },
}

---------- INACTIVE ----------

gls.short_line_left[1] = {
    BufferType = {
        provider = function()
            local ft = require('galaxyline.provider_buffer').get_buffer_filetype()
            local fname = require('galaxyline.provider_fileinfo').get_current_file_name()
            if fname ~= '' then
                return fname
            else
                return ft
            end
        end,
        highlight = { colors.fg, colors.line_bg, 'bold' },
    },
}

gls.short_line_left[2] = {
    Line = {
        provider = function()
            return ' '
        end,
        highlight = { colors.fg, colors.line_bg, 'bold' },
    },
}

gls.short_line_right[1] = {
    BufferIcon = {
        provider = 'BufferIcon',
        highlight = { colors.fg, colors.bg },
    },
}
