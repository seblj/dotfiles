---------- GITSIGNS CONFIG ----------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local popup = require('gitsigns.popup')

autocmd('BufNew', {
    pattern = '*',
    group = augroup('BlameGitmoji', { clear = true }),
    callback = function()
        vim.defer_fn(function()
            local winid = popup.is_open('blame')
            if winid then
                vim.api.nvim_win_call(winid, function()
                    local gitmoji_file = '~/dotfiles/nvim/lua/config/telescope/gitmoji.json'
                    local gitmojis = vim.json.decode(require('plenary.path'):new(gitmoji_file):read())
                    vim.bo.modifiable = true
                    for _, v in pairs(gitmojis) do
                        vim.cmd.substitute({
                            string.format('/%s/%s/gI', v.code, v.emoji),
                            range = { 1, vim.api.nvim_buf_line_count(0) },
                            mods = { emsg_silent = true },
                        })
                    end
                    vim.bo.modifiable = false
                end)
            end
        end, 0)
    end,
})

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

        map('n', '<leader>gm', gs.blame_line, { desc = 'Gitsigns: Git blame current line' })
        map('n', '<leader>gn', gs.next_hunk, { desc = 'Gitsigns: Go to next diff hunk' })
        map('n', '<leader>gp', gs.prev_hunk, { desc = 'Gitsigns: Go to previous diff hunk' })
        map('n', '<leader>gd', gs.preview_hunk, { desc = 'Gitsigns: Preview diff hunk' })
        map('n', '<leader>grh', gs.reset_hunk, { desc = 'Gitsigns: Reset diff hunk over cursor' })
        map('n', '<leader>grb', gs.reset_buffer, { desc = 'Gitsigns: Reset diff for entire buffer' })
    end,
})
