---------- STARTIFY CONFIG ----------

vim.g.startify_enable_special = 0
vim.g.startify_files_number = 6

vim.g.startify_commands = {
    { 'Dotfiles', 'lua require("config.telescope.utils").edit_dotfiles()' },
    { 'Packer sync', 'Packer sync' },
    { 'Packer install', 'Packer install' },
    { 'StartupTime', 'StartupTime' },
}

vim.g.startify_lists = {
    { type = 'commands', header = { '   Commands' } },
    { type = 'files', header = { '   MRU' } },
}

function _G.webDevIcons(path)
    local filename = vim.fn.fnamemodify(path, ':t')
    local extension = vim.fn.fnamemodify(path, ':e')
    return require('nvim-web-devicons').get_icon(filename, extension, { default = true })
end

vim.api.nvim_exec(
    [[
function! StartifyEntryFormat() abort
  return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
endfunction
]],
    false
)
