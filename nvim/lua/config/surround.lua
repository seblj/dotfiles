local keymap = vim.keymap.set

-- Don't really use s or S, so map to surround for easier access
keymap("n", "s", "<Plug>Ysurround", { desc = "Surround with motion" })
keymap("n", "S", "<Plug>Yssurround", { desc = "Surround entire line" })
keymap("v", "s", "<Plug>VSurround", { desc = "Surround visual" })
