---------- STARTIFY CONFIG ----------

vim.g.startify_enable_special = 0
vim.g.startify_files_number = 6

vim.g.startify_commands = {
    { 'Dotfiles', 'lua require("config.telescope.utils").edit_dotfiles()' },
    { 'PackerSync', 'PackerSync' },
    { 'PackerCompile', 'PackerCompile' },
    { 'StartupTime', 'StartupTime' },
}

vim.g.startify_lists = {
    { type = 'commands', header = { '   Commands' } },
    { type = 'files', header = { '   MRU' } },
}
