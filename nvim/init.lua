---------- INITIALIZE CONFIG ----------

if require('seblj.first_load')() then
    return
end

require('seblj.globals')
require('seblj.options')
require('seblj.keymaps')
require('seblj.plugins')

local augroup = require('seblj.utils').augroup

augroup('TestingSomething', {
    event = 'BufEnter',
    pattern = '*.lua',
    modifier = 'silent!',
    command = function()
        print('herere')
    end,
})
