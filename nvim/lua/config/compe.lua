---------- COMPE CONFIG ----------

local utils = require('seblj.utils')
local opt, map = vim.opt, utils.map

opt.completeopt = {'menuone', 'noselect'}
map('i', '<C-space>', 'compe#complete()', {expr = true})

require('compe').setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;
    allow_prefix_unmatch = false;

    source = {
        path = true;
        buffer = true;
        calc = false;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = false;
    };
}

-- vim.g.loaded_compe_buffer = 1
-- vim.g.loaded_compe_nvim_lsp = 1
-- vim.g.loaded_compe_nvim_lua = 1
-- vim.g.loaded_compe_omni = 1
-- vim.g.loaded_compe_path = 1
vim.g.loaded_compe_calc = 0
vim.g.loaded_compe_emoji = 0
vim.g.loaded_compe_luasnip = 0
vim.g.loaded_compe_snippets_nvim = 0
vim.g.loaded_compe_spell = 0
vim.g.loaded_compe_tags = 0
vim.g.loaded_compe_treesitter = 0
vim.g.loaded_compe_ultisnips = 0
vim.g.loaded_compe_vim_lsc = 0
vim.g.loaded_compe_vim_lsp = 0
vim.g.loaded_compe_vsnip = 0
