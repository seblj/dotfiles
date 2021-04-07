---------- COMPLETION CONFIG ----------

local utils = require('utils')
local cmd, opt, map = vim.cmd, utils.opt, utils.map

map('i', '<C-space>', '<Plug>(completion_trigger)', {noremap = false})
opt('o', 'completeopt', 'menuone,noinsert,noselect')
cmd("autocmd BufEnter * lua require('completion').on_attach()")

require('completion').addCompletionSource('vimtex', require('completion_sources/vimtex').complete_item)

vim.g.completion_confirm_key = ""
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
            {complete_items = {'buffers'}}
        },
        tex = {
            {complete_items = {'vimtex', 'lsp'}}
        },
        comment = {
            {complete_items = {'buffers'}}
        },
        string = {
            {complete_items = {'path'}, triggered_only = {'/'}},
        },
    }
}


-- vim.g.completion_customize_lsp_label = {
--     Function = ' [function]',
--     Method = ' [method]',
--     Reference = ' [refrence]',
--     Enum = ' [enum]',
--     Field = 'ﰠ [field]',
--     Keyword = ' [key]',
--     Variable = ' [variable]',
--     Folder = ' [folder]',
--     Snippet = ' [snippet]',
--     Operator = ' [operator]',
--     Module = ' [module]',
--     Text = 'ﮜ[text]',
--     Class = ' [class]',
--     Interface = ' [interface]'
-- }

