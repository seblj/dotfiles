---------- NOTIFY ----------

vim.notify = require("notify")

require("notify").setup({
    max_width = function()
        return math.floor(vim.o.columns / 3)
    end,
})
