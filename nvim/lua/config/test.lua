---------- TEST CONFIG ----------

local nnoremap = vim.keymap.nnoremap

vim.cmd([[let test#enabled_runners = ["python#djangotest", "python#pyunit"] ]])

if packer_plugins['vim-ultest'] and packer_plugins['vim-ultest'].loaded then
    nnoremap({ '<leader>tf', '<cmd>Ultest<CR>' })
    nnoremap({ '<leader>tn', '<cmd>UltestNearest<CR>' })
    nnoremap({ '<leader>tc', '<cmd>UltestClear<CR>' })
else
    nnoremap({ '<leader>tf', '<cmd>TestFile<CR>' })
    nnoremap({ '<leader>tn', '<cmd>TestNearest<CR>' })
end
