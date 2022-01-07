---------- INITIALIZE CONFIG ----------

if require('seblj.first_load')() then
    return
end

pcall(require, 'impatient')
require('seblj.globals')
require('seblj.options')
require('seblj.keymaps')
require('seblj.plugins')
