vim.g.startify_enable_special = 0
vim.g.startify_files_number = 6
vim.g.startify_change_to_dir = 0

vim.g.startify_commands = {
    { "Dotfiles", 'lua vim.api.nvim_input("<space>fd")' },
    { "Lazy sync", "Lazy sync" },
    { "Lazy update", "Lazy update" },
    { "Lazy profile", "Lazy profile" },
}

vim.g.startify_lists = {
    { type = "commands", header = { "   Commands" } },
    { type = "files", header = { "   MRU" } },
}

function _G.webDevIcons(path)
    local filename = vim.fn.fnamemodify(path, ":t")
    local extension = vim.fn.fnamemodify(path, ":e")
    return require("nvim-web-devicons").get_icon(filename, extension, { default = true })
end

vim.cmd([[
    function! StartifyEntryFormat() abort
      return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
    endfunction
]])

return { "mhinz/vim-startify", dependencies = "nvim-tree/nvim-web-devicons" }
