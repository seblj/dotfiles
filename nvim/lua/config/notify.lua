vim.notify = require("notify")

require("notify").setup({
    minimum_width = math.floor(vim.o.columns / 3),
    max_width = math.floor(vim.o.columns / 3),
    -- on_open = function(win)
    --     vim.wo[win].wrap = true
    --     -- Hopefully less annoying interrupts from rust_analyzer
    --     if vim.bo.filetype == "rust" then
    --         local history = require("notify").history()
    --         local last = history[#history]
    --         if string.match(unpack(last.message), "rust_analyzer") then
    --             vim.api.nvim_win_close(win, true)
    --             print(unpack(last.message))
    --         end
    --     end
    -- end,
})
