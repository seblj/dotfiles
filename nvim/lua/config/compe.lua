local utils = require('seblj.utils')
local opt, map = utils.opt, utils.map

opt.completeopt = 'menuone,noselect'
map('i', '<C-space>', 'compe#complete()', {expr = true})

require'compe'.setup {
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
    nvim_lua = false; -- Enabled by sumneko
    vsnip = false;
  };
}
