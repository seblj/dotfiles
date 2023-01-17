---------- OPTIONS ----------

vim.cmd.colorscheme("colorscheme")

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 100
vim.opt.cmdheight = 1
vim.opt.inccommand = "split"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cindent = true
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 20
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.shortmess:append("c")
vim.opt.cinkeys:remove("0#")
vim.opt.fillchars:append("diff:╱")
vim.opt.laststatus = 3
vim.opt.textwidth = 80

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.vimsyn_embed = "l"
