---------- DEBUGGER CONFIG ----------

---------- MAPPINGS ----------

local function keymap(mode, lhs, rhs, opts)
    opts.desc = string.format("Dap: %s", opts.desc)
    vim.keymap.set(mode, lhs, function()
        rhs()
        vim.fn["repeat#set"](vim.keycode(lhs))
    end, opts)
end

keymap("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Add breakpoint" })
keymap("n", "<leader>d<leader>", require("dap").continue, { desc = "Continue debugging" })
keymap("n", "<leader>dl", require("dap").step_into, { desc = "Step into" })
keymap("n", "<leader>dj", require("dap").step_over, { desc = "Step over" })

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
