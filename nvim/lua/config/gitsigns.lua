---------- GITSIGNS CONFIG ----------

local open_or_attach = function(filetype, callback)
    local found = false
    local wininfo = vim.fn.getwininfo()
    for _, win in ipairs(wininfo) do
        if vim.api.nvim_buf_get_option(win.bufnr, 'ft') == filetype then
            found = true
            vim.cmd.wincmd({ 'w', count = win.winnr })
        end
    end
    if not found then
        callback()
    end
end

require('gitsigns').setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~_' },
    },
    preview_config = {
        border = CUSTOM_BORDER,
    },
    max_file_length = 200000,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(m, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(m, l, r, opts)
        end

        map('n', '<leader>gm', function()
            open_or_attach('gitsigns_blame', gs.blame_line)
        end, { desc = 'Gitsigns: Git blame current line' })

        map('n', '<leader>gn', gs.next_hunk, { desc = 'Gitsigns: Go to next diff hunk' })
        map('n', '<leader>gp', gs.prev_hunk, { desc = 'Gitsigns: Go to previous diff hunk' })
        map('n', '<leader>gd', function()
            open_or_attach('gitsigns_diff', gs.preview_hunk)
        end, { desc = 'Gitsigns: Preview diff hunk' })
        map('n', '<leader>grh', gs.reset_hunk, { desc = 'Gitsigns: Reset diff hunk over cursor' })
        map('n', '<leader>grb', gs.reset_buffer, { desc = 'Gitsigns: Reset diff for entire buffer' })
    end,
})
