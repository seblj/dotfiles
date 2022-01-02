local keymap = {}

function keymap.set(mode, lhs, rhs, opts)
    vim.validate({
        mode = { mode, { 's', 't' } },
        lhs = { lhs, 's' },
        rhs = { rhs, { 's', 'f' } },
        opts = { opts, 't', true },
    })

    opts = opts or {}

    if opts.silent == nil then
        opts.silent = true
    end

    local buffer = false
    local is_rhs_lua = type(rhs) == 'function'
    mode = type(mode) == 'string' and { mode } or mode

    if opts.buffer ~= nil then
        buffer = opts.buffer == true and 0 or opts.buffer
        opts.buffer = nil
    end

    if opts.replace_termcodes ~= nil then
        if opts.replace_termcodes and is_rhs_lua then
            local user_rhs = rhs
            rhs = function()
                return vim.api.nvim_replace_termcodes(user_rhs(), true, true, true)
            end
        end
        opts.replace_termcodes = nil
    end

    -- remap defaults to false
    opts.noremap = true
    if opts.remap ~= nil then
        opts.noremap = not opts.remap
        opts.remap = nil
    end

    if is_rhs_lua then
        opts.callback = rhs
        rhs = ''
    end

    if buffer == false then
        for _, m in ipairs(mode) do
            vim.api.nvim_set_keymap(m, lhs, rhs, opts)
        end
    else
        for _, m in ipairs(mode) do
            vim.api.nvim_buf_set_keymap(buffer, m, lhs, rhs, opts)
        end
    end
end

vim.keymap = vim.keymap or keymap

return keymap
