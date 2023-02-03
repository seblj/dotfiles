---------- NOTIFY ----------

vim.notify = require("notify")

require("notify").setup({
    minimum_width = math.floor(vim.o.columns / 3),
    max_width = math.floor(vim.o.columns / 3),
})
