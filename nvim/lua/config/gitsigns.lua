---------- GITSIGNS CONFIG ----------

vim.api.nvim_create_autocmd("BufNew", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("BlameGitmoji", { clear = true }),
    callback = function()
        vim.defer_fn(function()
            local winid = require("gitsigns.popup").is_open("blame")
            if winid then
                vim.api.nvim_win_call(winid, function()
                    local gitmojis = vim.json.decode(require("plenary.path"):new("~/dotfiles/zsh/gitmoji.json"):read()) --[[@as table]]
                    vim.bo.modifiable = true
                    for _, v in pairs(gitmojis) do
                        vim.cmd.substitute({
                            string.format("/%s/%s/gI", v.code, v.emoji),
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

require("gitsigns").setup({
    preview_config = {
        border = CUSTOM_BORDER,
    },
    max_file_length = 30000,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(m, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            opts.desc = string.format("Gitsigns: %s", opts.desc)
            vim.keymap.set(m, l, r, opts)
        end

        map("n", "<leader>gm", gs.blame_line, { desc = "Git blame current line" })
        map("n", "<leader>gn", gs.next_hunk, { desc = "Go to next diff hunk" })
        map("n", "<leader>gp", gs.prev_hunk, { desc = "Go to previous diff hunk" })
        map("n", "<leader>gd", gs.preview_hunk, { desc = "Preview diff hunk" })
        map("n", "<leader>grh", gs.reset_hunk, { desc = "Reset diff hunk over cursor" })
        map("n", "<leader>grb", gs.reset_buffer, { desc = "Reset diff for entire buffer" })
    end,
})
