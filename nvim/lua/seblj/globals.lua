-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals/init.lua

P = function(v)
    print(vim.inspect(v))
    return v
end

if pcall(require, 'plenary') then
    RELOAD = require('plenary.reload').reload_module

    R = function(name)
        RELOAD(name)
        return require(name)
    end
end

-- Override vim.keymap.set to have silent as default
local map = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = vim.deepcopy(opts) or {}
    if opts.silent == nil then
        opts.silent = true
    end
    map(mode, lhs, rhs, opts)
end
