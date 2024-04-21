local M = {}

local mode_alias = {
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
}

local DIAGNOSTICS = {
    { "Error", "", "DiagnosticError" },
    { "Warn", "", "DiagnosticWarn" },
    { "Info", "I", "DiagnosticInfo" },
    { "Hint", "", "DiagnosticHint" },
}

local GIT_INFO = {
    { "added", "", "Added" },
    { "changed", "", "Changed" },
    { "removed", "", "Removed" },
}

local applied_highlights = {}
local background = "StatusLine"

local function highlight()
    local statusline_hl = "SebStatusline" .. background
    if not applied_highlights[background] then
        local colors = vim.api.nvim_get_hl(0, { name = background })
        local fg = vim.api.nvim_get_hl(0, { name = "Norma" }).fg
        vim.api.nvim_set_hl(0, statusline_hl, { fg = fg or colors.fg, bg = colors.bg })
        applied_highlights[background] = statusline_hl
    end
    return "%#" .. statusline_hl .. "#"
end

--- Only highlight fg for `name`
--- @param name string
--- @return string
local function hl(name)
    if applied_highlights[name] then
        name = applied_highlights[name]
    else
        local fg = vim.api.nvim_get_hl(0, { name = name }).fg
        local bg = vim.api.nvim_get_hl(0, { name = background }).bg

        local statusline_hl = "SebStatusline" .. name
        vim.api.nvim_set_hl(0, statusline_hl, { fg = fg, bg = bg })
        applied_highlights[name] = statusline_hl
        name = statusline_hl
    end
    return "%#" .. name .. "#"
end

local function get_os()
    if vim.fn.has("mac") == 1 then
        return "  "
    elseif vim.fn.has("linux") == 1 then
        return "  "
    else
        return "  "
    end
end

local function get_diagnostics()
    local diags = vim.diagnostic.count(0)
    local status = vim.iter(DIAGNOSTICS)
        :enumerate()
        :map(function(i, attrs)
            local n = diags[i] or 0
            if n > 0 then
                return ("%s%s %d"):format(hl(attrs[3]), attrs[2], n)
            end
        end)
        :totable()

    return #status == 0 and "" or table.concat(status, " ")
end

local function get_mode()
    local mode = mode_alias[vim.api.nvim_get_mode().mode]
    local color = "Error"
    return " " .. hl(color) .. mode .. "   "
end

local function get_filetype_symbol()
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return ""
    end

    local name = vim.api.nvim_buf_get_name(0)
    local ext = vim.fn.fnamemodify(name, ":e")
    local icon, iconhl = devicons.get_icon_color(name, ext, { default = true })

    local hlname = "SebStatusline" .. iconhl:gsub("#", "Status")
    vim.api.nvim_set_hl(0, hlname, { fg = iconhl })

    return hl(hlname) .. icon
end

local function get_file_info()
    local file_info = " %t"
    if vim.bo.readonly and vim.bo.modified then
        file_info = file_info .. "  " .. " "
    elseif vim.bo.readonly then
        file_info = file_info .. "  "
    elseif vim.bo.modified then
        file_info = file_info .. "  "
    end
    return file_info
end

local function get_git_branch()
    return vim.b.gitsigns_head and hl("Error") .. "  " .. vim.b.gitsigns_head or ""
end

local function get_git_status()
    local dict = vim.b.gitsigns_status_dict
    if not dict then
        return ""
    end

    local status = vim.iter(GIT_INFO)
        :map(function(val)
            local status = dict[val[1]]
            return status and status > 0 and (" %s%s %d"):format(hl(val[3]), val[2], status) or nil
        end)
        :totable()

    return table.concat(status)
end

--- @param sections string[][]
--- @return string
local function parse_sections(sections)
    local result = vim.iter(sections)
        :map(function(s)
            return table.concat(s)
        end)
        :totable()

    return table.concat(result, "%=")
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.api.nvim_create_augroup("statusline", { clear = true }),
    callback = function()
        vim.cmd.redrawstatus()
    end,
})

function M.statusline()
    return parse_sections({
        {
            highlight(),
            get_mode(),
            get_filetype_symbol(),
            highlight(),
            get_file_info(),
            highlight(),
            get_git_branch(),
            get_git_status(),
        },
        {
            highlight(),
            get_diagnostics(),
            highlight(),
            get_os(),
            " %2l:%c %3p%% ",
        },
    })
end

vim.o.statusline = "%{%v:lua.require('seblj.statusline').statusline()%}"

return M
