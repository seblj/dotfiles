-- Some inspiration from https://github.com/JoosepAlviste/nvim-ts-context-commentstring

local react = {
    jsx_element = "{/* %s */}",
    jsx_fragment = "{/* %s */}",
    jsx_attribute = "// %s",
    comment = "// %s",
    call_expression = "// %s",
    statement_block = "// %s",
    spread_element = "// %s",
}

local config = {
    tsx = react,
    javascript = react,
}

local lang_to_ft = {
    markdown_inline = "markdown",
    latex = "tex",
    c_sharp = "cs",
}

local uncomment_calculation_config = {
    c = { "//%s", "/*%s*/" },
    c_sharp = { "//%s", "/*%s*/" },
    tsx = { "//%s", "{/*%s*/}" },
    javascript = { "//%s", "{/*%s*/}" },
}

local function uncomment_calculation(language)
    local function uncomment_match(commentstring)
        local curr_line = vim.api.nvim_get_current_line():gsub("%s+", "")
        local str = vim.split(commentstring, "%s", { plain = true })

        local start = string.sub(curr_line, 0, #str[1]):gsub("%s+", "")
        local last = string.sub(curr_line, 0 - #str[2], -1):gsub("%s+", "")

        return str[1] == start and (str[2] == last or #str[2] == 0)
    end

    for _, commentstring in pairs(uncomment_calculation_config[language] or {}) do
        if uncomment_match(commentstring) then
            return commentstring
        end
    end
end

local function get_lang(parser, range)
    for lang, child in pairs(parser:children()) do
        if lang ~= "comment" and child:contains(range) then
            return get_lang(child, range)
        end
    end
    return parser:lang()
end

local function check_node(node, language_config)
    -- We have reached the top-most node
    if not node then
        return vim.filetype.get_option(vim.bo.ft, "commentstring")
    end

    local node_conf = language_config[node:type()]
    return node_conf and node_conf or check_node(node:parent(), language_config)
end

local function calculate_commentstring()
    if not vim.treesitter.language.get_lang(vim.bo.ft) then
        return vim.bo.commentstring
    end

    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local col = vim.fn.match(vim.api.nvim_get_current_line(), "\\S")
    local range = { row, col, row, col }

    -- Get the language tree with nodes inside the given range
    local parser = vim.treesitter.get_parser()
    local lang = get_lang(parser, range)

    local commentstring = uncomment_calculation(lang)
    if commentstring then
        return commentstring
    end

    local tree = parser:tree_for_range(range)
    if not config[lang] or not tree then
        return vim.filetype.get_option(lang_to_ft[lang] and lang_to_ft[lang] or lang, "commentstring")
    end

    local node = tree:root():named_descendant_for_range(unpack(range))
    return check_node(node, config[lang])
end

vim.keymap.set({ "n", "x", "o" }, "gc", function()
    vim.bo.commentstring = calculate_commentstring()
    return "<Plug>Commentary"
end, { expr = true })

vim.keymap.set("n", "gcc", function()
    vim.bo.commentstring = calculate_commentstring()
    return "<Plug>CommentaryLine"
end, { expr = true })

vim.keymap.set("n", "gcu", function()
    vim.bo.commentstring = calculate_commentstring()
    return "<Plug>Commentary<Plug>Commentary"
end, { expr = true })
