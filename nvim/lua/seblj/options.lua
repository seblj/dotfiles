---------- OPTIONS ----------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.cmd.colorscheme('colorscheme')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 100
vim.opt.cmdheight = 1
vim.opt.inccommand = 'split'
vim.opt.clipboard = 'unnamedplus'
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cindent = true
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 20
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.shortmess:append('c')
vim.opt.cinkeys:remove('0#')
vim.opt.fillchars:append('diff:╱')
vim.opt.laststatus = 3
vim.opt.textwidth = 80

-- Avoid nesting neovim sessions
vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
local group = augroup('SebGroup', { clear = true })
autocmd('FileType', {
    group = group,
    pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
    callback = function()
        vim.bo.bufhidden = 'delete'
    end,
    desc = 'Set bufhidden to delete',
})

autocmd('FileType', {
    group = group,
    pattern = '*',
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - 'o' + 'r' + 'c' - 't'
    end,
    desc = 'Fix formatoptions',
})

autocmd('TextYankPost', {
    group = group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
        if vim.env.SSH_CONNECTION then
            -- See if I should get from another register
            local ok, yank_data = pcall(vim.fn.getreg, '0')
            if ok and #yank_data > 0 then
                local Job = require('plenary.job')
                local data = nil
                Job:new({
                    command = 'base64',
                    writer = yank_data,
                    on_exit = function(j, _)
                        data = table.concat(j:result())
                    end,
                }):sync()
                vim.fn.chansend(vim.v.stderr, string.format('\x1b]52;c;%s\x07', data))
            end
        end
    end,
    desc = 'Highlight on yank',
})

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.vimsyn_embed = 'l'
