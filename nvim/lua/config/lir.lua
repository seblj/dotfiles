---------- FILE EXPLORER CONFIG ----------

local actions = require("lir.actions")

require("lir").setup({
    show_hidden_files = true,
    devicons = { enable = true },
    on_init = function()
        vim.keymap.set("n", "<C-x>", actions.split, { buffer = true, desc = "Lir: Open horizontal split" })
        vim.keymap.set("n", "<C-v>", actions.vsplit, { buffer = true, desc = "Lir: Open vertical split" })
        vim.keymap.set("n", "<C-t>", actions.tabedit, { buffer = true, desc = "Lir: Open new tab" })
        vim.keymap.set("n", "<CR>", actions.edit, { buffer = true, desc = "Lir: Open file" })
        vim.keymap.set("n", "..", actions.up, { buffer = true, desc = "Lir: Go one directory up" })
        vim.keymap.set("n", "Y", actions.yank_path, { buffer = true, desc = "Lir: Yank path" })
        vim.keymap.set("n", "dd", actions.delete, { buffer = true, desc = "Lir: Delete" })
        vim.keymap.set("n", "N", actions.touch, { buffer = true, desc = "Lir: Create new file" })
        vim.keymap.set("n", "M", actions.mkdir, { buffer = true, desc = "Lir: Create new directory" })
        vim.keymap.set("n", "r", actions.rename, { buffer = true, desc = "Lir: Rename" })

        require("seblj.utils").setup_hidden_cursor()
    end,
})
