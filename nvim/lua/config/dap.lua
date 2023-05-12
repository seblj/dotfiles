---------- DEBUGGER CONFIG ----------

---------- MAPPINGS ----------

vim.keymap.set("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
    vim.fn["repeat#set"](vim.keycode("<leader>db"))
end, { desc = "Dap: Add breakpoint" })

vim.keymap.set("n", "<leader>d<leader>", function()
    require("dap").continue()
    vim.fn["repeat#set"](vim.keycode("<leader>d<leader>"))
end, { desc = "Dap: Continue debugging" })

vim.keymap.set("n", "<leader>dl", function()
    require("dap").step_into()
    vim.fn["repeat#set"](vim.keycode("<leader>dl"))
end, { desc = "Dap: Step into" })

vim.keymap.set("n", "<leader>dj", function()
    require("dap").step_over()
    vim.fn["repeat#set"](vim.keycode("<leader>dj"))
end, { desc = "Dap: Step over" })

---------- UI ----------

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

require("dapui").setup({
    icons = {
        expanded = "",
        collapsed = "",
        circular = "↺",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {

            elements = {
                "repl",
            },
            size = 10,
            position = "bottom",
        },
    },
})
