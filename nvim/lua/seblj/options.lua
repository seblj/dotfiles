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

-- Titlestring
function _G.modified()
    if vim.bo.modified then
        return ""
    else
        return ""
    end
end

function _G.devicon()
    local ok, web = pcall(require, "nvim-web-devicons")
    local bufname = vim.api.nvim_buf_get_name(0)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    local extension = vim.fn.fnamemodify(bufname, ":e")

    if ok then
        local icon = web.get_icon(filename, extension, { default = true })
        return icon
    else
        return ""
    end
end

vim.opt.title = true
vim.opt.titlestring = [[%{luaeval('devicon()')} %t %{luaeval('modified()')}]]
