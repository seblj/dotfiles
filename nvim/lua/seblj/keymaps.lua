---------- MAPPINGS ----------

local utils = require("seblj.utils")

-- Leader is space and localleader is \
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---------- GENERAL MAPPINGS ----------

vim.keymap.set({ "n", "x", "i" }, "√", "<A-j>", { remap = true, desc = "Fix <A-j> mapping on mac" })
vim.keymap.set({ "n", "x", "i" }, "ª", "<A-k>", { remap = true, desc = "Fix <A-k> mapping on mac" })

vim.keymap.set({ "n", "x", "i" }, "∆", "<A-j>", { remap = true, desc = "Fix <A-j> mapping on mac" })
vim.keymap.set({ "n", "x", "i" }, "˚", "<A-k>", { remap = true, desc = "Fix <A-k> mapping on mac" })

vim.keymap.set("n", "<C-i>", "<C-i>")
vim.keymap.set("n", "<Tab>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<S-TAB>", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Resize all splits" })
vim.keymap.set("n", "<CR>", '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', { expr = true, desc = "Remove highlights" })
vim.keymap.set("n", "gb", "<C-t>", { desc = "Go back in tag-stack" })
vim.keymap.set("n", "gp", "`[v`]", { desc = "Reselect pasted text" })
vim.keymap.set("n", "<C-t>", ":tabedit<CR>", { desc = "Create new tab" })

vim.keymap.set({ "n", "x" }, "d", '"+d')
vim.keymap.set({ "n", "x" }, "p", '"+p')
vim.keymap.set({ "n", "x" }, "y", '"+y')
vim.keymap.set({ "n", "x" }, "Y", '"+y$')
vim.keymap.set({ "n", "x" }, "x", '"_x')

vim.keymap.set({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete into black hole register" })
vim.keymap.set({ "n", "x" }, "<leader>c", '"_c', { desc = "Change into black hole register" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Delete into black hole register on visual paste" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right split" })

vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Navigate to left split" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Navigate to bottom split" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Navigate to top split" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Navigate to right split" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape from term-mode" })

vim.keymap.set("n", "<leader>gh", ":help <C-r><C-w><CR>", { desc = "Search in help for word under cursor" })

vim.keymap.set("x", "<", "<gv", { desc = "Keep visual mode on dedent" })
vim.keymap.set("x", ">", ">gv", { desc = "Keep visual mode on indent" })

vim.keymap.set("n", "<A-j>", ":m.+1<CR>==", { desc = "Move current line down" })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move current line down" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line down" })

vim.keymap.set("n", "<A-k>", ":m.-2<CR>==", { desc = "Move current line up" })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move current line up" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line up" })

vim.keymap.set("x", "<leader>sr", [["sy:let @/=@s<CR>cgn]], { desc = "Replace word under cursor" })
vim.keymap.set("n", "<leader>sr", [[:let @/='\<'.expand('<cword>').'\>'<CR>cgn]], {
    desc = "Replace word under cursor",
})
vim.keymap.set("n", "<leader>sa", [[:let @/='\<'.expand('<cword>').'\>'<CR>cgn<C-r>"]], {
    desc = "Append to word under cursor",
})

vim.keymap.set("", "<leader>j", "J", { desc = "Join [count] lines" })

vim.keymap.set("n", "j", 'v:count ? "j" : "gj"', { expr = true, desc = "gj" })
vim.keymap.set("n", "k", 'v:count ? "k" : "gk"', { expr = true, desc = "gk" })

vim.keymap.set({ "n", "x" }, "J", "10gj")
vim.keymap.set({ "n", "x" }, "K", "10gk")

vim.keymap.set({ "n", "x", "o" }, "H", "^", { desc = "Move to beginning of line" })
vim.keymap.set({ "n", "x", "o" }, "L", "$", { desc = "Move to end of line" })

vim.keymap.set("n", "<leader>x", utils.save_and_exec, { desc = "Save and execute file" })

vim.keymap.set("n", "<Down>", function()
    if vim.tbl_isempty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) then
        vim.cmd.normal("j")
    else
        vim.cmd.cnext({ mods = { emsg_silent = true } })
    end
end, { desc = "Move down in qflist" })

vim.keymap.set("n", "<Up>", function()
    if vim.tbl_isempty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) then
        vim.cmd.normal("k")
    else
        vim.cmd.cprev({ mods = { emsg_silent = true } })
    end
end, { desc = "Move up in qflist" })

vim.keymap.set("n", "<leader>z", "<cmd>Inspect<CR>", { desc = "Print syntax under cursor" })

vim.keymap.set("n", "<leader>@", "<cmd>lcd %:p:h<CR><cmd>pwd<CR>", { desc = "cd to directory of open buffer" })

vim.keymap.set("n", "<leader>tm", function()
    if vim.o.mouse == "nvi" then
        vim.opt.mouse = ""
        vim.opt.signcolumn = "no"
    else
        vim.opt.mouse = "nvi"
        vim.opt.signcolumn = "auto"
    end
    vim.opt.number = not vim.o.number
    vim.opt.relativenumber = not vim.o.relativenumber
end, {
    desc = "Toggle mouse, number and signcolumn",
})

vim.keymap.set("n", "<leader>tf", function()
    vim.b.disable_formatting = not vim.b.disable_formatting
    local res = vim.b.disable_formatting and "Disabled" or "Enabled"
    vim.api.nvim_echo({ { string.format("%s autoformat on save", res) } }, false, {})
end, { desc = "Format: Toggle format on save" })

vim.keymap.set("n", "<leader>ts", function()
    vim.opt.spelllang = vim.o.spelllang == "en" and "nb" or "en"
    print("Setting spelllang to", vim.o.spelllang)
end, { desc = "Toggle spelllang between english and norwegian" })

vim.keymap.set("n", "<leader>m", function()
    if vim.t.maximized then
        vim.t.maximized = false
        vim.cmd.tabclose()
    elseif vim.fn.winnr("$") ~= 1 then
        vim.cmd.split({ mods = { tab = 1 } })
        vim.t.maximized = true
    end
end, { desc = "Maximize current split" })

---------- ABBREVIATIONS ----------

vim.keymap.set("ca", "!!", "<C-r>:") -- Repeat last command
vim.keymap.set("ca", "Q", "q") -- Quit with Q
vim.keymap.set("ca", "W", "w") -- Write with W
vim.keymap.set("ca", "WQ", "wq") -- Write and quit with WQ
vim.keymap.set("ca", "Wq", "wq") -- Write and quit with Wq
vim.keymap.set("ca", "Wqa", "wqa") -- Write and quit all with Wqa
vim.keymap.set("ca", "WQa", "wqa") -- Write and quit all with WQa
vim.keymap.set("ca", "WQA", "wqa") -- Write and quit all with WQA
vim.keymap.set("ca", "Wa", "wa") -- Write all with Wa
vim.keymap.set("ca", "WA", "wa") -- Write all with WA
vim.keymap.set("ca", "Qa", "qa") -- Quit all with Qa
vim.keymap.set("ca", "QA", "qa") -- Quit all with QA
vim.keymap.set("ca", "E", "e") -- Edit file with E
vim.keymap.set("ca", "TERM", "term")
vim.keymap.set("ca", "TERm", "term")
vim.keymap.set("ca", "TErm", "term")
vim.keymap.set("ca", "Term", "term")
vim.keymap.set("ca", "make", "Make")

-- Open term in splits
local opts = { nargs = "*", bang = true }

---@param key string
---@param direction "new" | "vnew" | "tabnew"
local function create_command(key, direction)
    local function completion(_, cmdline, _)
        vim.cmd.lcd(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        local run_command = vim.split(cmdline, key .. " ")[2]
        return utils.get_zsh_completion(run_command)
    end
    opts.complete = completion
    vim.api.nvim_create_user_command(key, function(x)
        utils.term({ direction = direction, focus = true, cmd = x.args, new = true })
    end, opts)
end
create_command("T", "new")
create_command("VT", "vnew")
create_command("TT", "tabnew")
vim.api.nvim_create_user_command("Make", function(x)
    vim.cmd.make({ args = { x.args }, bang = true, mods = { silent = true } })
    vim.cmd.copen()
end, {
    nargs = "*",
})
