---------- AUTOPAIRS CONFIG ----------

require('nvim-autopairs').setup({
    disable_filetype = { 'TelescopePrompt', 'UIPrompt' },
    ignored_next_char = '[%w%.%{%[%(%"%\']',
})
