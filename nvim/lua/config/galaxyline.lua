---------- STATUSLINE CONFIG ----------

local utils = require('seblj.utils')
local augroup = utils.augroup
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

local has = function(item)
    return vim.fn.has(item) == 1
end

local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
    end
    return false
end

-- Get wordcount in latex document. Only update the count on save
local latex_word_count = nil
augroup('UpdateWordCount', {
    event = 'BufWritePost',
    pattern = '*.tex',
    command = function()
        latex_word_count = string.format('Words: %s', vim.fn['vimtex#misc#wordcount']())
    end,
})
local get_word_count = function()
    if not latex_word_count then
        latex_word_count = string.format('Words: %s', vim.fn['vimtex#misc#wordcount']())
    end
    return latex_word_count
end

---------- LEFT ----------

local mode = {
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
}

local file_icon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { require('galaxyline.providers.fileinfo').get_file_icon_color, colors.line_bg },
}

local file_name = {
    provider = function()
        if vim.api.nvim_buf_get_option(0, 'ft') == 'dirbuf' then
            return vim.fn.expand('%:p:h')
        end
        return require('galaxyline.providers.fileinfo').get_current_file_name()
    end,
    condition = function()
        if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
            return true
        end
        if vim.api.nvim_buf_get_option(0, 'ft') == 'dirbuf' then
            return true
        end
        return false
    end,
    highlight = { colors.fg, colors.line_bg, 'bold' },
}

local git_icon = {
    provider = function()
        return '  '
    end,
    condition = require('galaxyline.providers.vcs').get_git_branch,
    highlight = { colors.red, colors.line_bg, 'bold' },
}

local git_branch = {
    provider = 'GitBranch',
    condition = require('galaxyline.providers.vcs').get_git_branch,
    highlight = { colors.red, colors.line_bg, 'bold' },
    separator = ' ',
    separator_highlight = { colors.bg, colors.line_bg },
}

local diff_add = {
    provider = 'DiffAdd',
    condition = checkwidth,
    -- icon = ' ',
    icon = ' ',
    highlight = { colors.green, colors.line_bg },
}

local diff_modified = {
    provider = 'DiffModified',
    condition = checkwidth,
    -- icon = ' ',
    icon = ' ',
    highlight = { colors.blue, colors.line_bg },
}

local diff_remove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    -- icon = ' ',
    icon = ' ',
    highlight = { colors.red, colors.line_bg },
}

---------- RIGHT ----------

local diagnostic_error = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = { colors.red, colors.line_bg },
}

local diagnostic_warning = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = { colors.orange, colors.line_bg },
}
local diagnostic_hint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = { colors.yellow, colors.line_bg },
}

local os = {
    provider = function()
        if has('mac') then
            return 'macOS'
        elseif has('linux') then
            return 'Linux'
        end
    end,
    separator = ' ',
    separator_highlight = { colors.bg, colors.line_bg },
    highlight = { colors.fg, colors.line_bg, 'bold' },
}

local line_info = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = { colors.blue, colors.line_bg },
    highlight = { colors.fg, colors.line_bg },
}
local file_percent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = { colors.line_bg, colors.line_bg },
    highlight = { colors.fg, colors.line_bg, 'bold' },
}
local latex_num_words = {
    provider = function()
        return get_word_count()
    end,
    condition = function()
        return vim.api.nvim_buf_get_option(0, 'ft') == 'tex'
    end,
    separator_highlight = { colors.line_bg, colors.line_bg },
    highlight = { colors.fg, colors.line_bg, 'bold' },
}

---------- INACTIVE ----------

local buffer_type = {
    provider = function()
        local ft = require('galaxyline.providers.buffer').get_buffer_filetype()
        local fname = require('galaxyline.providers.fileinfo').get_current_file_name()
        if fname ~= '' then
            return fname
        else
            return ft
        end
    end,
    highlight = { colors.fg, colors.line_bg, 'bold' },
}

local line = {
    provider = function()
        return ' '
    end,
    highlight = { colors.fg, colors.line_bg, 'bold' },
}

local buffer_icon = {
    provider = 'BufferIcon',
    highlight = { colors.fg, colors.bg },
}

---------- ASSEMBLE ----------

gls.left = {
    { mode = mode },
    { file_icon = file_icon },
    { file_name = file_name },
    { git_icon = git_icon },
    { git_branch = git_branch },
    { diff_add = diff_add },
    { diff_modified = diff_modified },
    { diff_remove = diff_remove },
}

gls.right = {
    { diagnostic_error = diagnostic_error },
    { diagnostic_warning = diagnostic_warning },
    { diagnostic_hint = diagnostic_hint },
    { latex_num_words = latex_num_words },
    { os = os },
    { line_info = line_info },
    { file_percent = file_percent },
}

gls.short_line_left = {
    { buffer_type = buffer_type },
    { line = line },
}

gls.short_line_right = {
    { buffer_icon = buffer_icon },
}
