local get_option = vim.filetype.get_option

local react = {
    jsx_element = "{/* %s */}",
    jsx_fragment = "{/* %s */}",
    jsx_attribute = "// %s",
    call_expression = "// %s",
    statement_block = "// %s",
    spread_element = "// %s",
}

local config = {
    tsx = react,
    javascript = react,
}

local uncomment_calculation_config = {
    c = { "// %s", "/* %s */" },
    c_sharp = { "// %s", "/* %s */" },
    tsx = { "// %s", "{/* %s */}" },
    javascript = { "// %s", "{/* %s */}" },
}

local function uncomment_calculation(language)
    local function uncomment_match(commentstring)
        local curr_line = vim.api.nvim_get_current_line():gsub("%s+", "")
        local str = vim.split(commentstring, "%s", { plain = true })

        local start = string.sub(curr_line, 0, #str[1]):gsub("%s+", "")
        local last = string.sub(curr_line, 0 - #str[2], -1):gsub("%s+", "")

        return str[1] == start and (str[2] == last or #str[2] == 0)
    end

    return vim.iter(uncomment_calculation_config[language] or {}):find(function(commentstring)
        return uncomment_match(commentstring)
    end)
end

---@diagnostic disable-next-line: duplicate-set-field
function vim.filetype.get_option(ft, option)
    if option ~= "commentstring" then
        return get_option(ft, option)
    end

    local lang = vim.treesitter.language.get_lang(ft) or ft

    local commentstring = uncomment_calculation(lang)
    if commentstring then
        return commentstring
    end

    -- First non whitespace character
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local col = vim.fn.match(vim.api.nvim_get_current_line(), "\\S")

    local spec = config[lang]
    local ok, node = pcall(vim.treesitter.get_node, { ignore_injections = false, pos = { row, col } })
    while ok and spec and node do
        if spec[node:type()] then
            return spec[node:type()]
        end
        node = node:parent()
    end

    return get_option(ft, "commentstring")
end
