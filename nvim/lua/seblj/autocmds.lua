---------- AUTOCMDS ----------

local group = vim.api.nvim_create_augroup("SebGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
    end,
    desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("VimResized", { group = group, command = "tabdo wincmd =" })

---@param ft string[] | string
---@param fn function
local function set_ft_option(ft, fn)
    ft = type(ft) == "table" and ft or { ft }
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = ft,
        desc = string.format("FileType options for: %s", unpack(ft)),
        callback = fn,
    })
end

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
set_ft_option({ "gitcommit", "gitrebase", "gitconfig" }, function()
    vim.bo.bufhidden = "delete"
end)

set_ft_option({ "text", "tex", "markdown", "gitcommit" }, function()
    vim.opt_local.spell = true
end)

set_ft_option(
    { "json", "html", "javascript", "typescript", "typescriptreact", "javascriptreact", "css", "vue" },
    function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
)

set_ft_option("*", function()
    vim.opt.formatoptions = vim.opt.formatoptions - "o"
end)

set_ft_option("graphql", function()
    vim.opt_local.commentstring = "# %s"
end)

set_ft_option({ "c", "cs" }, function()
    vim.opt_local.commentstring = "// %s"
end)

set_ft_option({ "sql" }, function()
    vim.opt_local.commentstring = "-- %s"
end)

set_ft_option("vue", function()
    vim.opt_local.commentstring = "<!-- %s -->"
    vim.opt.formatoptions:remove("r")
end)

set_ft_option("help", function()
    vim.keymap.set("n", "gd", "K", { buffer = true })
end)

set_ft_option("term", function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("$")
    vim.cmd.startinsert()
end)

set_ft_option("startify", function()
    require("seblj.utils").setup_hidden_cursor()
end)
