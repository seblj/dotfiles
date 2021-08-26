---------- AUTOPAIRS CONFIG ----------

local inoremap = vim.keymap.inoremap
local npairs = require('nvim-autopairs')

if not Use_coc then
    seblj.completion_confirm = function()
        return npairs.autopairs_cr()
    end
    inoremap({ '<CR>', 'v:lua.seblj.completion_confirm()', expr = true })
end

npairs.setup({
    disable_filetype = { 'TelescopePrompt', 'UIPrompt' },
})
