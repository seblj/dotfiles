local inoremap = vim.keymap.inoremap

inoremap({
    '<C-space>',
    function()
        require('cmp').complete()
    end,
})

require('cmp').setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    documentation = {
        border = 'rounded',
    },
})

vim.opt.completeopt = { 'menuone', 'noselect' }
require('cmp_nvim_lsp').setup({})
