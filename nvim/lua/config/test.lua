---------- TEST CONFIG ----------

local map = require('seblj.utils').map

vim.cmd([[let test#enabled_runners = ["python#djangotest", "python#pyunit"] ]])
map('n', '<leader>tf', '<cmd>Ultest<CR>')
map('n', '<leader>tn', '<cmd>UltestNearest<CR>')
map('n', '<leader>tc', '<cmd>UltestClear<CR>')
