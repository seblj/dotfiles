---------- OPTIONS ----------

vim.cmd.colorscheme(COLORSCHEME)

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 100
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 20
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.cindent = true
vim.opt.cinkeys:remove("0#")
vim.opt.shortmess:append("c")
vim.opt.fillchars:append("diff:╱")
vim.opt.laststatus = 3
vim.opt.textwidth = 80
vim.opt.wrap = false

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.title = true
vim.opt.titlestring = [[%{luaeval('titlestring()')}]]

-- Titlestring
function _G.titlestring()
    local modified = vim.bo.modified and "" or ""

    local ok, web = pcall(require, "nvim-web-devicons")
    local bufname = vim.api.nvim_buf_get_name(0)
    local filename = vim.fs.basename(bufname)
    local extension = vim.fn.fnamemodify(bufname, ":e")

    local icon = ok and web.get_icon(filename, extension, { default = true }) or ""
    local name = vim.api.nvim_eval_statusline("%t", {}).str
    return string.format("%s %s %s", modified, name, icon)
end
