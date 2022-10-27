-- Some inspiration from https://github.com/JoosepAlviste/nvim-ts-context-commentstring

local react = {
    jsx_element = '{/* %s */}',
    jsx_fragment = '{/* %s */}',
    jsx_attribute = '// %s',
    comment = '// %s',
    call_expression = '// %s',
    statement_block = '// %s',
    spread_element = '// %s',
}

local config = {
    tsx = react,
    javascript = react,
}

local uncomment_calculation_config = {
    c = { '// %s', '/* %s */' },
    c_sharp = { '// %s', '/* %s */' },
    tsx = { '// %s', '{/* %s */}' },
    javascript = { '// %s', '{/* %s */}' },
}

local parsers = require('nvim-treesitter.parsers')

local get_ft_commentstring = function(ft)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].ft = ft
    return vim.bo[buf].commentstring
end

local default_commentstring = function(ft)
    if vim.bo.ft == ft then
        return get_ft_commentstring(ft)
    end
    local filetypes = vim.fn.getcompletion('', 'filetype')
    for _, lang in ipairs(filetypes) do
        if lang == ft then
            return get_ft_commentstring(ft)
        end
    end
    return vim.bo.commentstring
end

local uncomment_calculation = function(language)
    local parse_line = function(commentstring)
        local curr_line = vim.api.nvim_get_current_line()
        local first_char = vim.fn.match(curr_line, '\\S')

        local a = vim.split(commentstring, '%s', { plain = true })
        local first = a[1]:gsub('%s+', '')
        local second = a[2]:gsub('%s+', '')

        local start = string.sub(curr_line, first_char, first_char + #first):gsub('%s+', '')
        local last = string.sub(curr_line, 0 - #second, -1):gsub('%s+', '')

        if first == start and (second == last or #second == 0) then
            return commentstring
        end
        return nil
    end

    local commentstrings = uncomment_calculation_config[language] or {}
    for _, commentstring in pairs(commentstrings) do
        local found = parse_line(commentstring)
        if found then
            return found
        end
    end
end

local function contains(tree, range)
    for lang, child in pairs(tree:children()) do
        if lang ~= 'comment' and child:contains(range) then
            return contains(child, range)
        end
    end
    return tree
end

local function check_node(node, language_config)
    -- We have reached the top-most node
    if not node or not language_config then
        return default_commentstring()
    end

    local node_type = node:type()
    return language_config[node_type] and language_config[node_type] or check_node(node:parent(), language_config)
end

local function calculate_commentstring()
    if not parsers.has_parser() then
        return default_commentstring()
    end

    local location = {
        vim.api.nvim_win_get_cursor(0)[1] - 1,
        vim.fn.match(vim.fn.getline('.'), '\\S'),
    }

    local range = {
        location[1],
        location[2],
        location[1],
        location[2],
    }

    -- Get the language tree with nodes inside the given range
    local root = parsers.get_parser()
    local lang = contains(root, { unpack(range) }):lang()

    if uncomment_calculation_config[lang] then
        local commentstring = uncomment_calculation(lang)
        if commentstring then
            return commentstring
        end
    end

    if not config[lang] then
        return default_commentstring(lang)
    end

    local tree = root.tree_for_range(root, range, {})
    if not tree then
        return default_commentstring(lang)
    end
    local node = tree:root():named_descendant_for_range(unpack(range))

    return check_node(node, config[lang])
end

vim.keymap.set({ 'n', 'x', 'o' }, 'gc', function()
    vim.bo.commentstring = calculate_commentstring()
    return '<Plug>Commentary'
end, { expr = true })

vim.keymap.set('n', 'gcc', function()
    vim.bo.commentstring = calculate_commentstring()
    return '<Plug>CommentaryLine'
end, { expr = true })

vim.keymap.set('n', 'gcu', function()
    vim.bo.commentstring = calculate_commentstring()
    return '<Plug>Commentary<Plug>Commentary'
end, { expr = true })
