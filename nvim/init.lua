---------- INITIALIZE CONFIG ----------

if require('seblj.first_load')() then
    return
end

pcall(require, 'impatient')
require('seblj.globals')
require('seblj.utils.keymap')

-- Override vim.keymap.set to have silent as default
local map = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = vim.deepcopy(opts) or {}
    if opts.silent == nil then
        opts.silent = true
    end
    map(mode, lhs, rhs, opts)
end

require('seblj.options')
require('seblj.keymaps')
require('seblj.plugins')
