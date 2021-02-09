---------- LUATREE CONFIG ----------

local g = vim.g

g.nvim_tree_icons = {
    default = ''
}
g.nvim_tree_ignore = { '.git', 'node_modules', '.cache', '.DS_Store' }
g.nvim_tree_git_hl = 1

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    for c in mode:gmatch"." do
        vim.api.nvim_set_keymap(c, lhs, rhs, options)
    end
end

map('n', '<leader>tt', ':NvimTreeToggle<CR>')
