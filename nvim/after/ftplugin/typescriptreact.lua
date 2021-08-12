local inoremap = vim.keymap.nnoremap

vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

inoremap({ '<C-c>', '<Esc>T<"iyiw$a</<ESC>"ipa><ESC>F<i' })
