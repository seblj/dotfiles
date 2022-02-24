---------- GITSIGNS CONFIG ----------

require('gitsigns').setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~_' },
    },
    preview_config = {
        border = 'rounded',
    },
    max_file_length = 200000,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(m, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(m, l, r, opts)
        end

        map('n', '<leader>gm', gs.blame_line, { desc = 'Gitsigns: Git blame current line' })
        map('n', '<leader>gn', gs.next_hunk, { desc = 'Gitsigns: Go to next diff hunk' })
        map('n', '<leader>gp', gs.prev_hunk, { desc = 'Gitsigns: Go to previous diff hunk' })
        map('n', '<leader>gd', gs.preview_hunk, { desc = 'Gitsigns: Preview diff hunk' })
        map('n', '<leader>grh', gs.reset_hunk, { desc = 'Gitsigns: Reset diff hunk over cursor' })
        map('n', '<leader>grb', gs.reset_buffer, { desc = 'Gitsigns: Reset diff for entire buffer' })
    end,
})
