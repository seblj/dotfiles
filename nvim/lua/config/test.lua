---------- TEST CONFIG ----------

local nnoremap = vim.keymap.nnoremap

vim.g['test#javascript#runner'] = 'jest'
vim.g['test#typescript#runner'] = 'jest'

vim.g['test#javascript#executable'] = 'yarn test:unit'
vim.g['test#typescript#executable'] = 'yarn test:unit'

vim.g.ultest_use_pty = 1

if packer_plugins['vim-ultest'] and packer_plugins['vim-ultest'].loaded then
    nnoremap({ '<leader>tf', '<cmd>Ultest<CR>' })
    nnoremap({ '<leader>tn', '<cmd>UltestNearest<CR>' })
    nnoremap({ '<leader>tc', '<cmd>UltestClear<CR>' })
else
    nnoremap({ '<leader>tf', '<cmd>TestFile<CR>' })
    nnoremap({ '<leader>tn', '<cmd>TestNearest<CR>' })
end
