---------- OPTIONS ----------

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

---------- KEYMAPS ----------

vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "J", "10j")
vim.keymap.set({ "n", "v" }, "K", "10k")

vim.keymap.set({ "n", "x", "o" }, "H", "^", { desc = "Move to beginning of line" })
vim.keymap.set({ "n", "x", "o" }, "L", "$", { desc = "Move to end of line" })

vim.keymap.set("n", "j", 'v:count ? "j" : "gj"', { expr = true, desc = "gj" })
vim.keymap.set("n", "k", 'v:count ? "k" : "gk"', { expr = true, desc = "gk" })

vim.keymap.set("", "<leader>j", "J", { desc = "Join [count] lines" })

vim.keymap.set("x", "<", "<gv", { desc = "keep visual mode on dedent" })
vim.keymap.set("x", ">", ">gv", { desc = "keep visual mode on indent" })

vim.keymap.set({ "n", "x", "i" }, "√", "<A-j>", { remap = true, desc = "Fix <A-j> mapping on mac" })
vim.keymap.set({ "n", "x", "i" }, "ª", "<A-k>", { remap = true, desc = "Fix <A-k> mapping on mac" })

vim.keymap.set({ "n", "x", "i" }, "∆", "<A-j>", { remap = true, desc = "Fix <A-j> mapping on mac" })
vim.keymap.set({ "n", "x", "i" }, "˚", "<A-k>", { remap = true, desc = "Fix <A-k> mapping on mac" })

vim.keymap.set("n", "<leader>x", ":source ~/dotfiles/vscode/init.lua<CR>")
vim.keymap.set("n", "gcc", "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")
vim.keymap.set({ "x", "o" }, "gc", "<Cmd>call VSCodeNotify('editor.action.commentLine')<CR>")

vim.keymap.set({ "n", "i", "x" }, "<A-j>", "<Cmd>call VSCodeNotify('editor.action.moveLinesDownAction')<CR>")
vim.keymap.set({ "n", "i", "x" }, "<A-k>", "<Cmd>call VSCodeNotify('editor.action.moveLinesUpAction')<CR>")

---------- AUTOCMDS ----------

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("Yank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
	desc = "Highlight on yank",
})
