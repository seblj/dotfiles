---------- COMPLETION CONFIG ----------

local function map(mode, lhs, rhs, opts)
  local options = {silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
    for c in mode:gmatch"." do
        vim.api.nvim_set_keymap(c, lhs, rhs, options)
    end
end


local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

opt('o', 'completeopt', 'menuone,noinsert,noselect')

vim.cmd("autocmd BufEnter * lua require'completion'.on_attach()")

require'completion'.addCompletionSource('vimtex', require'completion_sources/vimtex'.complete_item)

vim.g.completion_auto_change_source = 1
vim.g.completion_sorting = "length"
vim.g.completion_items_duplicate = {
    lsp = 0,
    vimtex = 0
}
vim.g.completion_trigger_on_delete = 1
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.g.completion_chain_complete_list = {
    default = {
        default = {
            {complete_items = {'lsp'}},
            {complete_items = {'path'}},
            {complete_items = {'buffers'}}
        },
        tex = {
            {complete_items = {'vimtex', 'lsp'}}
        },
        comment = {
            {complete_items = {'buffers'}}
        },
        string = {
            {complete_items = {'path'}}
        },
    }
}

map('i', '<C-space>', '<Plug>(completion_trigger)')
