local keymap = vim.keymap.set
require('harpoon').setup({})

keymap('n', '<leader>ha', function()
    require('harpoon.mark').add_file()
    local file = vim.fn.expand('%:t')
    print(file .. ' added to harpoon')
end, {
    desc = 'Harpoon: Add file',
})

keymap('n', '<leader>he', function()
    require('harpoon.ui').toggle_quick_menu()
    vim.cmd('mapclear <buffer>')
    -- stylua: ignore start
    -- Add mapping myself because I like to silent the mapping and not print it out
    keymap('n', '<CR>', function() require('harpoon.ui').select_menu_item() end, { buffer = true })
    keymap('n', 'q', function() require('harpoon.ui').toggle_quick_menu() end, { buffer = true })
    keymap('n', '<ESC>', function() require('harpoon.ui').toggle_quick_menu() end, { buffer = true })
end, {
    desc = 'Harpoon: Toggle menu',
})
