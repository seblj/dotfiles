local bufnr = 2

local raw_colors = vim.api.nvim_get_hl(0, { create = false })
local map = {}

local ignore = {
    "SB$",
    "^Alpha",
    "^CmpItem.*Default$",
    "^Copilot",
    "^DapUI",
    "^Dashboard",
    "^DevIcon",
    "^DiagnosticFloating",
    "^DiagnosticSign",
    "^DiagnosticVirtualText",
    "^DropBar",
    "^Flash",
    "^GitConflict",
    "^GitSigns",
    "^GlyphPalette",
    "^Ibl",
    "^Illuminated",
    "^LspDiagnostics",
    "^LspInfo",
    "^Neogit",
    "^Nvim",
    "^Oil",
    "^RainbowDelimiter",
    "^RedrawDebug",
    "^SebStatusline",
    "^TabLineClose",
    "^TabLineDevIcon",
    "^TabLineModified",
    "^TabLinePadding",
    "^TabLineSeparator",
    "^Telescope",
    "^TreesitterContext",
    "^Ufo",
    "^[a-z]", -- Lowercase
    "^_DropBar",
}

local whitelist = {
    "^GitSignsAddInline$",
    "^GitSignsDeleteInline$",
    "^GitSignsAddLn$",
}

local function find_and_update(acc, it)
    if it ~= nil and acc[it] ~= nil then
        acc[it] = acc[it] + 1
    elseif it ~= nil then
        acc[it] = 1
    end
end

local function sort_table(tbl)
    -- Convert the table into a list of key-value pairs
    local sorted_list = {}
    for key, value in pairs(tbl) do
        table.insert(sorted_list, { key = key, value = value })
    end

    -- Sort the list based on the values
    table.sort(sorted_list, function(a, b)
        return a.value > b.value
    end)

    local c = {}
    local num = 1
    for _, v in pairs(sorted_list) do
        c[v.key] = string.format("color%d", num)
        num = num + 1
    end
    return c
end

local num_colors = {}
local highlights = vim.iter(raw_colors)
    :filter(function(k, _)
        local found = vim.iter(ignore):find(function(it)
            return string.match(k, it)
        end)

        local found_whitelist = vim.iter(whitelist):find(function(_it)
            return string.match(k, _it)
        end)

        return not found or found_whitelist
    end)
    :fold({}, function(t, k, v)
        t[k] = v
        v.sp = v.sp and string.format("#%x", v.sp) or nil
        v.fg = v.fg and string.format("#%x", v.fg) or nil
        v.bg = v.bg and string.format("#%x", v.bg) or nil

        find_and_update(num_colors, v.sp)
        find_and_update(num_colors, v.bg)
        find_and_update(num_colors, v.fg)
        return t
    end)

local colors = sort_table(num_colors)

for k, v in pairs(highlights) do
    v.cterm = nil
    v.ctermbg = nil
    v.ctermfg = nil

    local existing_link = vim.iter(vim.tbl_keys(highlights)):find(function(_v)
        return _v == v.link
    end)

    if v.link and not existing_link then
        local hl = vim.api.nvim_get_hl(0, { name = v.link })
        if hl then
            ---@diagnostic disable-next-line: assign-type-mismatch
            hl.sp = hl.sp and string.format("#%x", hl.sp) or nil

            ---@diagnostic disable-next-line: assign-type-mismatch
            hl.fg = hl.fg and string.format("#%x", hl.fg) or nil

            ---@diagnostic disable-next-line: assign-type-mismatch
            hl.bg = hl.bg and string.format("#%x", hl.bg) or nil
        end

        v = hl and hl or {}
    end

    v.sp = colors[v.sp]
    v.fg = colors[v.fg]
    v.bg = colors[v.bg]

    local key = string.sub(k, 1, 1) == "@" and string.format('["%s"]', k) or k

    local val = string.gsub(string.gsub(vim.inspect(vim.tbl_isempty(v) and {} or v), "\n", " "), "%s+", " ")
    local s = string.format("    %s = %s,", key, val)
    map[#map + 1] = s
end

local color_map = vim.iter(colors):fold({}, function(t, k, v)
    t[v] = k
    return t
end)

local func = vim.split(
    [[
local function highlight(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end
]],
    "\n"
)

vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, func)

color_map = vim.split(vim.inspect(color_map), "\n")
color_map[1] = "local c = " .. color_map[1]

local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

vim.api.nvim_buf_set_lines(bufnr, #lines, -1, false, color_map)

lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

table.sort(map)
table.insert(map, 1, "highlight({")
table.insert(map, "})")

vim.api.nvim_buf_set_lines(bufnr, #lines, -1, false, map)
vim.api.nvim_buf_call(bufnr, function()
    vim.cmd([[%s/"color\(\d\+\)"/c.color\1/g]])
end)
