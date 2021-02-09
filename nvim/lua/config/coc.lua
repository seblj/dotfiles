---------- COC CONFIG ----------

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local cmd = vim.cmd

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
    local options = {silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    for c in mode:gmatch"." do
        vim.api.nvim_set_keymap(c, lhs, rhs, options)
    end
end

opt('o', 'completeopt', 'menuone,noinsert,noselect')
map('n', 'gd', '<Plug>(coc-definition)')
map('n', 'gr', '<Plug>(coc-references)')
map('n', '<leader>cd', '<Plug>(coc-diagnostic-info)')
map('i', '<c-space>', 'coc#refresh()', {expr = true})
cmd('command! -nargs=0 Prettier :CocCommand prettier.formatFile')

-- Autoformat closing tags
map('i', '<CR>', 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>\\<C-r>=coc#on_enter()\\<CR>"', {noremap = true, expr = true})
