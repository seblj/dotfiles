---------- NOTIFY ----------

return {
    config = function()
        require("notify").setup({
            max_width = function()
                return math.floor(vim.o.columns / 3)
            end,
        })
    end,

    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                vim.notify = require("notify")
            end,
        })
    end,
}
