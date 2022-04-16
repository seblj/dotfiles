-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals/init.lua

P = function(...)
    for _, v in ipairs({ ... }) do
        print(vim.inspect(v))
    end
end

if pcall(require, 'plenary') then
    RELOAD = require('plenary.reload').reload_module

    R = function(name)
        RELOAD(name)
        return require(name)
    end
end
CUSTOM_BORDER = { '', '▄', '', '█', '', '▀', '', '█' }

-- Override vim.keymap.set to have silent as default
local map = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = vim.deepcopy(opts) or {}
    if opts.silent == nil then
        opts.silent = true
    end
    map(mode, lhs, rhs, opts)
end
