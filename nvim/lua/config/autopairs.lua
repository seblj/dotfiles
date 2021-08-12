---------- AUTOPAIRS CONFIG ----------

local inoremap = vim.keymap.inoremap
local npairs = require('nvim-autopairs')

if not Use_coc then
    seblj.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info()['selected'] ~= -1 then
                return vim.fn['compe#confirm'](npairs.esc('<cr>'))
            else
                return npairs.esc('<cr>')
            end
        else
            return npairs.autopairs_cr()
        end
    end
    inoremap({ '<CR>', 'v:lua.seblj.completion_confirm()', expr = true })
end

npairs.setup({
    disable_filetype = { 'TelescopePrompt', 'UIPrompt' },
})

if not Use_coc then
    -- Ugly fix for compes bug https://github.com/hrsh7th/nvim-compe/issues/436
    local parenthesis_rule = npairs.get_rule('(')
    parenthesis_rule:with_pair(function()
        if vim.fn.pumvisible() == 1 then
            vim.cmd([[ call timer_start(0, { -> luaeval('require"compe"._close()') }) ]])
        end
        return true
    end)
end
