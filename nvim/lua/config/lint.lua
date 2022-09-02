local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local lint = require('lint')
lint.linters_by_ft = {
    python = { 'pylint' },
}

autocmd({ 'BufWritePost', 'BufEnter', 'BufLeave', 'InsertLeave' }, {
    group = augroup('NvimLint', { clear = true }),
    callback = function()
        lint.try_lint()
    end,
    desc = 'NvimLint',
})
