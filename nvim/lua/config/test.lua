---------- TEST CONFIG ----------

local nnoremmap = vim.keymap.nnoremap

vim.cmd([[let test#enabled_runners = ["python#djangotest", "python#pyunit"] ]])

if packer_plugins['vim-ultest'] and packer_plugins['vim-ultest'].loaded then
    nnoremmap({ '<leader>tf', '<cmd>Ultest<CR>' })
    nnoremmap({ '<leader>tn', '<cmd>UltestNearest<CR>' })
    nnoremmap({ '<leader>tc', '<cmd>UltestClear<CR>' })
else
    nnoremmap({ '<leader>tf', '<cmd>TestFile<CR>' })
    nnoremmap({ '<leader>tn', '<cmd>TestNearest<CR>' })
end
