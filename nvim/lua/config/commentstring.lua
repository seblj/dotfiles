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

    return vim.iter(uncomment_calculation_config[language] or {}):find(function(commentstring)
        return uncomment_match(commentstring)
    end)
end

local function default_commentstring(lang)
    local ft = vim.iter(vim.treesitter.language.get_filetypes(lang)):find(function(ft)
        return vim.filetype.get_option(ft, "commentstring") ~= ""
    end)
    return vim.filetype.get_option(ft or vim.bo.filetype, "commentstring")
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
    -- Get the language tree with nodes inside the given range
    local ok, parser = pcall(vim.treesitter.get_parser)
    if not ok then
        return vim.bo.commentstring
    end

    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local col = vim.fn.match(vim.api.nvim_get_current_line(), "\\S")
    local range = { row, col, row, col }
    local lang = get_lang(parser, range)

    local commentstring = uncomment_calculation(lang)
    if commentstring then
        return commentstring
    end

    local tree = parser:tree_for_range(range)
    if not config[lang] or not tree then
        return default_commentstring(lang)
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

return { "tpope/vim-commentary" }
