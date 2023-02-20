local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

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
        init = function(self)
            self.mode = vim.fn.mode()
            if not self.once then
                vim.api.nvim_create_autocmd("ModeChanged", {
                    pattern = "*:*o",
                    command = "redrawstatus",
                })
                self.once = true
            end
        end,
        static = {
            mode_names = {
                ["n"] = "NORMAL",
                ["no"] = "OP",
                ["nov"] = "OP",
                ["noV"] = "OP",
                ["no"] = "OP",
                ["niI"] = "NORMAL",
                ["niR"] = "NORMAL",
                ["niV"] = "NORMAL",
                ["v"] = "VISUAL",
                ["vs"] = "VISUAL",
                ["V"] = "LINES",
                ["Vs"] = "LINES",
                [""] = "BLOCK",
                ["s"] = "BLOCK",
                ["s"] = "SELECT",
                ["S"] = "SELECT",
                [""] = "BLOCK",
                ["i"] = "INSERT",
                ["ic"] = "INSERT",
                ["ix"] = "INSERT",
                ["R"] = "REPLACE",
                ["Rc"] = "REPLACE",
                ["Rv"] = "V-REPLACE",
                ["Rx"] = "REPLACE",
                ["c"] = "COMMAND",
                ["cv"] = "COMMAND",
                ["ce"] = "COMMAND",
                ["r"] = "ENTER",
                ["rm"] = "MORE",
                ["r?"] = "CONFIRM",
                ["!"] = "SHELL",
                ["t"] = "TERM",
                ["nt"] = "TERM",
                ["null"] = "NONE",
            },
            mode_colors = {
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
        },
        provider = function(self)
            return string.format(" %s  ", self.mode_names[self.mode])
        end,
        hl = function(self)
            return { bg = colors.bg, fg = self.mode_colors[self.mode_names[self.mode]], bold = true }
        end,
        update = { "ModeChanged" },
    },
    file_info = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
            self.extension = vim.fn.fnamemodify(self.filename, ":e")
            self.icon, self.icon_color =
                require("nvim-web-devicons").get_icon_color(self.filename, self.extension, { default = true })
        end,
        hl = { bg = colors.bg },
        {
            provider = function(self)
                return string.format(" %s", self.icon)
            end,
            hl = function(self)
                return { fg = self.icon_color, bold = true }
            end,
        },
        {
            provider = function(self)
                local basename = vim.fs.basename(self.filename)
                local name = basename ~= "" and basename or "[No Name]"
                return string.format(" %s", name)
            end,
            hl = function()
                return { fg = colors.fg, bold = true }
            end,
        },
        {
            provider = " ",
            hl = { fg = colors.fg },
            condition = function()
                return vim.bo.readonly
            end,
        },
        {
            provider = "  ",
            hl = { fg = colors.fg },
            condition = function()
                return vim.bo.modified
            end,
        },
    },

    git = {
        condition = conditions.is_git_repo,
        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.add_count = self.status_dict.added or 0
            self.changed_count = self.status_dict.changed or 0
            self.removed_count = self.status_dict.removed or 0
        end,

        hl = { bg = colors.bg, fg = colors.red },
        static = {
            branch_icon = "",
            add_icon = "",
            changed_icon = "",
            removed_icon = "",
        },
        {
            provider = function(self)
                return string.format(" %s %s", self.branch_icon, self.status_dict.head)
            end,
            hl = { bold = true },
        },
        {
            provider = function(self)
                return self.add_count > 0 and string.format(" %s %s", self.add_icon, self.add_count)
            end,
            hl = { fg = colors.green },
        },
        {
            provider = function(self)
                return self.changed_count > 0 and string.format(" %s %s", self.changed_icon, self.changed_count)
            end,
            hl = { fg = colors.blue },
        },
        {
            provider = function(self)
                return self.removed_count > 0 and string.format(" %s %s", self.removed_icon, self.removed_count)
            end,
            hl = { fg = colors.red },
        },
    },
    diagnostics = {
        condition = conditions.has_diagnostics,
        update = { "DiagnosticChanged", "BufEnter" },

        static = {
            error_icon = "  ",
            warn_icon = "  ",
            hint_icon = "  ",
        },

        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        end,
        hl = { bg = colors.bg },

        {
            provider = function(self)
                return self.errors > 0 and (self.error_icon .. self.errors)
            end,
            hl = { fg = colors.red },
        },
        {
            provider = function(self)
                return self.warnings > 0 and (self.warn_icon .. self.warnings)
            end,
            hl = { fg = colors.orange },
        },
        {
            provider = function(self)
                return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
            end,
            hl = { fg = colors.yellow },
        },
    },
    os = {
        provider = function()
            if vim.fn.has("mac") == 1 then
                return "   "
            elseif vim.fn.has("linux") == 1 then
                return "   "
            end
        end,
        hl = { bg = colors.bg, fg = colors.fg },
    },
    file_position = {
        provider = "  %l:%c  ",
        hl = { bg = colors.bg, fg = colors.fg },
        {
            provider = function()
                local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                local lines = vim.api.nvim_buf_line_count(0)

                if curr_line == 1 then
                    return "Top"
                elseif curr_line == lines then
                    return "Bot"
                else
                    return string.format("%2d%%%%", math.ceil(curr_line / lines * 99))
                end
            end,
        },
    },
    latex_word_count = {
        provider = function()
            if not latex_word_count then
                latex_word_count = string.format(" Words: %s", vim.fn["vimtex#misc#wordcount"]())
            end
            return latex_word_count
        end,
        hl = { bg = colors.bg, fg = colors.fg },
        condition = function()
            return vim.bo.ft == "tex"
        end,
    },
    maximized = {
        provider = "Maximized",
        hl = { fg = colors.fg },
        condition = function()
            return vim.t.maximized
        end,
    },
    navic = {
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
        condition = function()
            return require("nvim-navic").is_available()
        end,
        hl = { bg = utils.get_highlight("Normal").bg },
    },
}

local statusline = {
    { components.vi_mode },
    { components.file_info },
    { components.git },
    { provider = "%=", hl = { bg = colors.bg } },
    { components.diagnostics },
    { components.latex_word_count },
    { components.os },
    { components.file_position },
}

local winbar = {
    { components.maximized },
    {
        components.file_info,
        hl = function()
            return { bg = utils.get_highlight("Normal").bg, force = true }
        end,
        condition = function()
            return vim.api.nvim_buf_get_name(0) ~= ""
        end,
    },
    { components.navic },
}

require("heirline").setup({
    statusline = statusline,
    winbar = winbar,
})

local blocked_fts = {
    "term",
    "startify",
    "NvimTree",
    "packer",
    "startuptime",
}

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
                win.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
            elseif win.diff then
                win.winbar = nil
            end
        end
    end,
})
