local nnoremap = vim.keymap.nnoremap
require('harpoon').setup({})

nnoremap({
    '<leader>ha',
    function()
        require('harpoon.mark').add_file()
        local file = vim.fn.expand('%:t')
        print(file .. ' added to harpoon')
    end,
})
nnoremap({
    '<leader>he',
    function()
        require('harpoon.ui').toggle_quick_menu()
        vim.cmd('mapclear <buffer>')
        -- stylua: ignore start
        -- Add mapping myself because I like to silent the mapping and not print it out
        nnoremap({ '<CR>', function() require('harpoon.ui').select_menu_item() end, buffer = true })
        nnoremap({ 'q', function() require('harpoon.ui').toggle_quick_menu() end, buffer = true })
        nnoremap({ '<ESC>', function() require('harpoon.ui').toggle_quick_menu() end, buffer = true })
    end,
})

nnoremap({ 'L', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>' })
nnoremap({ 'Ø', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>' })
nnoremap({ 'Æ', '<cmd>lua require("harpoon.ui").nav_file(3)<CR>' })
