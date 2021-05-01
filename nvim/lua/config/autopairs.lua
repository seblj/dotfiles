---------- AUTOPAIRS CONFIG ----------

local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

-- skip it, if you use another global object
_G.MUtils= {}

if not Use_coc then
    vim.g.completion_confirm_key = ""
    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0  then
            if vim.fn.complete_info()["selected"] ~= -1 then
                return vim.fn["compe#confirm"](npairs.esc("<cr>"))
            else
                return npairs.esc("<cr>")
            end
        else
            return npairs.autopairs_cr()
        end
    end
    remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
end



npairs.setup({
    ignored_next_char = "[^])}>]",
    close_triple_quotes = true
})
