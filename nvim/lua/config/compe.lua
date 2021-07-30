---------- COMPE CONFIG ----------

local map = require('seblj.utils.keymap')
local inoremap = map.inoremap
local imap = map.imap

vim.opt.completeopt = { 'menuone', 'noselect' }
inoremap({ '<C-space>', 'compe#complete()', expr = true })

require('compe').setup({
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    allow_prefix_unmatch = false,
    documentation = {
        border = 'rounded',
    },

    source = {
        path = true,
        buffer = true,
        calc = false,
        nvim_lsp = true,
        nvim_lua = false,
        vsnip = false,
        luasnip = {
            priority = 1000,
        },
    },
})

-- vim.g.loaded_compe_buffer = 1
-- vim.g.loaded_compe_nvim_lsp = 1
-- vim.g.loaded_compe_nvim_lua = 1
-- vim.g.loaded_compe_omni = 1
-- vim.g.loaded_compe_path = 1
vim.g.loaded_compe_calc = 0
vim.g.loaded_compe_emoji = 0
vim.g.loaded_compe_snippets_nvim = 0
vim.g.loaded_compe_spell = 0
vim.g.loaded_compe_tags = 0
vim.g.loaded_compe_treesitter = 0
vim.g.loaded_compe_ultisnips = 0
vim.g.loaded_compe_vim_lsc = 0
vim.g.loaded_compe_vim_lsp = 0
vim.g.loaded_compe_vsnip = 0

-- Ugly fix for compes bug https://github.com/hrsh7th/nvim-compe/issues/436
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.compe_close = function()
    require('compe')._close()
end

_G.compe_fix_bug = function(character)
    if vim.fn.pumvisible() == 1 then
        vim.cmd('call timer_start(0, { -> v:lua.compe_close() })')
        return t(character)
    end
    return t(character)
end

imap({ ',', 'v:lua.compe_fix_bug(",")', expr = true })
imap({ '<space>', 'v:lua.compe_fix_bug("<space>")', expr = true })
