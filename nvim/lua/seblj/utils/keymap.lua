local keymap = {}

function keymap.set(mode, lhs, rhs, opts)
    vim.validate({
        mode = { mode, { 's', 't' } },
        lhs = { lhs, 's' },
        rhs = { rhs, { 's', 'f' } },
        opts = { opts, 't', true },
    })

    opts = vim.deepcopy(opts) or {}
    local is_rhs_luaref = type(rhs) == 'function'
    mode = type(mode) == 'string' and { mode } or mode

    if is_rhs_luaref and opts.expr and opts.replace_keycodes ~= false then
        local user_rhs = rhs
        rhs = function()
            return vim.api.nvim_replace_termcodes(user_rhs(), true, true, true)
        end
    end
    -- clear replace_keycodes from opts table
    opts.replace_keycodes = nil

    if opts.remap == nil then
        -- remap by default on <plug> mappings and don't otherwise.
        opts.noremap = is_rhs_luaref or rhs:lower():match('^<plug>') == nil
    else
        -- remaps behavior is opposite of noremap option.
        opts.noremap = not opts.remap
        opts.remap = nil
    end

    if is_rhs_luaref then
        opts.callback = rhs
        rhs = ''
    end

    if opts.buffer then
        local bufnr = opts.buffer == true and 0 or opts.buffer
        opts.buffer = nil
        for _, m in ipairs(mode) do
            vim.api.nvim_buf_set_keymap(bufnr, m, lhs, rhs, opts)
        end
    else
        opts.buffer = nil
        for _, m in ipairs(mode) do
            vim.api.nvim_set_keymap(m, lhs, rhs, opts)
        end
    end
end

vim.keymap = vim.keymap or keymap

return keymap
