local keymap = vim.keymap.set

require('package-info').setup()

keymap('n', '<leader>nu', function()
    require('package-info').update()
    require('seblj.utils').setup_hidden_cursor()
end, {
    desc = 'Packageinfo: Update package on line',
})
keymap('n', '<leader>nd', function()
    require('package-info').delete()
    require('seblj.utils').setup_hidden_cursor()
end, {
    desc = 'Packageinfo: Delete package on line',
})
keymap('n', '<leader>ni', function()
    require('package-info').install()
    require('seblj.utils').setup_hidden_cursor()
end, {
    desc = 'Packageinfo: Install new package',
})
keymap('n', '<leader>nv', function()
    require('package-info').change_version()
    require('seblj.utils').setup_hidden_cursor()
end, {
    desc = 'Packageinfo: Change version of package on line',
})
