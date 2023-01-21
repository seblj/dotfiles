---------- DEBUGGER CONFIG ----------

local keymap = vim.keymap.set

---------- MAPPINGS ----------

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

keymap("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
    vim.fn["repeat#set"](t("<leader>db"))
end, { desc = "Dap: Add breakpoint" })

keymap("n", "<leader>d<leader>", function()
    require("dap").continue()
    vim.fn["repeat#set"](t("<leader>d<leader>"))
end, { desc = "Dap: Continue debugging" })

keymap("n", "<leader>dl", function()
    require("dap").step_into()
    vim.fn["repeat#set"](t("<leader>dl"))
end, { desc = "Dap: Step into" })

keymap("n", "<leader>dj", function()
    require("dap").step_over()
    vim.fn["repeat#set"](t("<leader>dj"))
end, { desc = "Dap: Step over" })

---------- UI ----------

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

local dapui = require("dapui")
dapui.setup({
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
