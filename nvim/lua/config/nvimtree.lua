---------- LUATREE CONFIG ----------

require("nvim-tree").setup()

vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>", { desc = "NvimTree: Toggle tree" })
