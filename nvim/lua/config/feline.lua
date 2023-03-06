---------- STATUSLINE CONFIG ----------

-- Get wordcount in latex document. Only update the count on save
local latex_word_count = nil
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("UpdateWordCount", {}),
    pattern = "*.tex",
    callback = function()
        latex_word_count = string.format(" Words: %s", vim.fn["vimtex#misc#wordcount"]())
    end,
    desc = "Update word count in latex",
})

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
                    file_modified_icon = "",
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
        provider = function()
            if vim.fn.has("mac") == 1 then
                return "  "
            elseif vim.fn.has("linux") == 1 then
                return "  "
            end
        end,
    },
    custom = {
        latex_words = {
            provider = function()
                if not latex_word_count then
                    latex_word_count = string.format(" Words: %s", vim.fn["vimtex#misc#wordcount"]())
                end
                return latex_word_count
            end,
            enabled = function()
                return vim.bo.filetype == "tex"
            end,
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
        components.custom.latex_words,
        components.os,
        components.file.position,
        components.file.percentage,
    },
}

require("feline").setup({
    theme = { bg = colors.bg, fg = colors.fg },
    components = { active = statusline, inactive = statusline },
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

local function get_color(group, attr)
    local color = vim.fn.synIDattr(vim.fn.hlID(group), attr)
    return color ~= "" and color or nil
end

---------- WINBAR ----------

local winbar_components = {
    maximized = {
        provider = function()
            return "Maximized"
        end,
        enabled = function()
            return vim.t.maximized
        end,
    },
    gps = {
        provider = function()
            local location = require("nvim-navic").get_location({
                highlight = true,
                separator = "  ",
                icons = vim.tbl_map(function(val)
                    return val .. " "
                end, require("seblj.utils.icons").kind),
            })
            return location == "" and "" or "  " .. location
        end,
        enabled = function()
            return require("nvim-navic").is_available()
        end,
    },
}

local winbar = {
    {
        winbar_components.maximized,
        vim.deepcopy(components.file.info),
        winbar_components.gps,
    },
}

-- Have winbar background to be the same as Normal
for _, val in pairs(winbar) do
    for _, component in pairs(val) do
        if not component.hl then
            component.hl = { bg = get_color("Normal", "bg") }
        end
        if not component.hl.bg then
            component.hl.bg = get_color("Normal", "bg")
        end
    end
end

local blocked_fts = {
    "term",
    "startify",
    "NvimTree",
    "packer",
    "startuptime",
}

require("feline").winbar.setup({
    theme = { bg = get_color("Normal", "bg") },
    components = { active = winbar, inactive = winbar },
    disable = {
        filetypes = blocked_fts,
    },
})

-- Hack to not enable winbar on all buffers
vim.api.nvim_create_autocmd({ "BufWinEnter", "TabNew", "TabEnter", "BufEnter", "WinClosed", "BufWritePost" }, {
    group = vim.api.nvim_create_augroup("AttachWinbar", { clear = true }),
    desc = "Winbar only on some buffers",
    callback = function()
        vim.o.winbar = ""
        for _, w in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf, win = vim.bo[vim.api.nvim_win_get_buf(w)], vim.wo[w]
            if
                not vim.tbl_contains(blocked_fts, buf.filetype)
                and vim.fn.win_gettype(vim.api.nvim_win_get_number(w)) == ""
                and buf.buftype == ""
                and buf.filetype ~= ""
                and not win.diff
            then
                win.winbar = "%{%v:lua.require'feline'.generate_winbar()%}"
            elseif win.diff then
                win.winbar = nil
            end
        end
    end,
})
