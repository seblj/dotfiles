---------- STATUSLINE CONFIG ----------

local colors = {
    bg = "#303030",
    fg = "#8FBCBB",
    none = "NONE",
    yellow = "#e7c664",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#afd700",
    orange = "#FF8800",
    purple = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
}

local components = {
    vi_mode = {
        provider = function()
            return string.format(" %s%s ", require("feline.providers.vi_mode").get_vim_mode(), "  ")
        end,
        hl = function()
            return {
                name = require("feline.providers.vi_mode").get_mode_highlight_name(),
                fg = require("feline.providers.vi_mode").get_mode_color(),
            }
        end,
    },
    file = {
        info = {
            provider = {
                name = "file_info",
                opts = {
                    file_readonly_icon = " ",
                    file_modified_icon = " ",
                },
            },
            hl = { style = "bold" },
        },
        position = {
            provider = "position",
            left_sep = {
                str = " | ",
                hl = { fg = colors.blue },
            },
            right_sep = " ",
        },
        percentage = {
            provider = "line_percentage",
            hl = { style = "bold" },
            left_sep = " ",
            right_sep = " ",
        },
    },
    diagnostics = {
        error = {
            provider = "diagnostic_errors",
            icon = "  ",
            hl = { fg = colors.red },
        },
        warning = {
            provider = "diagnostic_warnings",
            icon = "  ",
            hl = { fg = colors.orange },
        },
        hint = {
            provider = "diagnostic_hints",
            icon = "  ",
            hl = { fg = colors.yellow },
        },
    },
    git = {
        branch = {
            provider = "git_branch",
            icon = "  ",
            hl = { fg = colors.red, style = "bold" },
        },
        add = {
            provider = "git_diff_added",
            icon = "  ",
            hl = { fg = colors.green },
        },
        change = {
            provider = "git_diff_changed",
            icon = "  ",
            hl = { fg = colors.blue },
        },
        remove = {
            provider = "git_diff_removed",
            icon = "  ",
            hl = { fg = colors.red },
        },
    },
    os = {
        provider = {
            name = "os",
            update = { "VimEnter" },
        },
    },
}

local statusline = {
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
        components.os,
        components.file.position,
        components.file.percentage,
    },
}

require("feline").setup({
    theme = { bg = colors.bg, fg = colors.fg },
    components = { active = statusline, inactive = statusline },
    custom_providers = {
        os = function()
            if vim.fn.has("mac") == 1 then
                return "  "
            elseif vim.fn.has("linux") == 1 then
                return "  "
            else
                return "  "
            end
        end,
    },
    vi_mode_colors = {
        NORMAL = colors.green,
        INSERT = colors.red,
        VISUAL = colors.purple,
        OP = colors.green,
        BLOCK = colors.blue,
        REPLACE = colors.violet,
        ["V-REPLACE"] = colors.violet,
        ENTER = colors.cyan,
        MORE = colors.cyan,
        SELECT = colors.orange,
        COMMAND = colors.purple,
        SHELL = colors.green,
        TERM = colors.blue,
        NONE = colors.yellow,
    },
})
