require('refactoring').setup()
require('telescope').load_extension('refactoring')

vim.keymap.set(
    'v',
    '<leader>fr',
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { desc = 'Refactoring: Open menu' }
)
