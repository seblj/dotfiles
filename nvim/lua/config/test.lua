---------- TEST CONFIG ----------

local map = require('seblj.utils').map

vim.cmd([[let test#enabled_runners = ["python#djangotest", "python#pyunit"] ]])

if packer_plugins['vim-ultest'] and packer_plugins['vim-ultest'].loaded then
    map('n', '<leader>tf', '<cmd>Ultest<CR>')
    map('n', '<leader>tn', '<cmd>UltestNearest<CR>')
    map('n', '<leader>tc', '<cmd>UltestClear<CR>')
else
    map('n', '<leader>tf', '<cmd>TestFile<CR>')
    map('n', '<leader>tn', '<cmd>TestNearest<CR>')
end
