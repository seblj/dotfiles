---------- COC CONFIG ----------

local utils = require('seblj.utils')
local eval, opt, map, cmd, fn = vim.api.nvim_eval, utils.opt, utils.map, vim.cmd, vim.fn

opt('o', 'completeopt', 'menuone,noinsert,noselect')

map('n', 'gd', ':lua goto_definition()<CR>', {noremap = false})
map('n', 'gb', '<C-t>')
map('n', 'gh', ':lua show_documentation()<CR>')
map('n', 'gR', '<Plug>(coc-rename)', {noremap = false})
map('n', 'gr', 'mA<Plug>(coc-references)', {noremap = false})
map('n', 'gn', '<Plug>(coc-diagnostic-next)', {noremap = false})
map('n', 'gp', '<Plug>(coc-diagnostic-prev)', {noremap = false})
map('n', '<leader>ca', ':CocAction<CR>')
map('n', '<leader>cd', '<Plug>(coc-diagnostic-info)', {noremap = false})
map('i', '<c-space>', 'coc#refresh()', {expr = true})
map('n', '<leader>p', ':CocCommand prettier.formatFile<CR>')
-- Autoformat closing tags with vim-closetag
map('i', '<CR>', 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>\\<C-r>=coc#on_enter()\\<CR>"', {expr = true})

-- Show documentation under cursor
function _G.show_documentation()
    if (eval("index(['vim','help'], &filetype)") >= 0) then
        cmd([[execute 'h '.expand('<cword>')]])
    else
        fn.CocAction('doHover')
    end
end

-- Use tagstack for go to definition
function _G.goto_definition()
    local from = {vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0}
    local items = {{tagname = vim.fn.expand('<cword>'), from = from}}

    if fn.CocAction('jumpDefinition') then
        vim.fn.settagstack(vim.fn.win_getid(), {items=items}, 't')
    end
end
