local keymap = vim.keymap.set
local ui = require('harpoon.ui')
require('harpoon').setup({})

keymap('n', '<leader>ha', function()
    require('harpoon.mark').add_file()
    local file = vim.fn.expand('%:t')
    print(file .. ' added to harpoon')
end, {
    desc = 'Harpoon: Add file',
})

keymap('n', '<leader>he', function()
    ui.toggle_quick_menu()
    vim.cmd.mapclear('<buffer>')
    -- Add mapping myself because I like to silent the mapping and not print it out
    keymap('n', '<CR>', ui.select_menu_item, { buffer = true })
    keymap('n', 'q', ui.toggle_quick_menu, { buffer = true })
    keymap('n', '<ESC>', ui.toggle_quick_menu, { buffer = true })
end, {
    desc = 'Harpoon: Toggle menu',
})
