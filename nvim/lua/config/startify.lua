---------- STARTIFY ----------

local g = vim.g

g.startify_enable_special = 0
g.startify_files_number = 5

g.startify_commands = {
    {'Dotfiles', 'lua require("seblj.utils").edit_dotfiles()'},
    {'PackerSync', 'PackerSync'},
    {'PackerCompile', 'PackerCompile'},
    {'StartupTime', 'StartupTime'},
}

g.startify_lists = {
    {type = 'commands', header = {'   Commands'}},
    {type = 'files',    header = {'   MRU'}},
}
