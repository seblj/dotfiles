-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals/init.lua

Loaded_colorscheme = false

P = function(v)
    print(vim.inspect(v))
    return v
end

_G.__seblj_global_callbacks = __seblj_global_callbacks or {}

_G.seblj = {
    _store = __seblj_global_callbacks,
}

if pcall(require, 'plenary') then
    RELOAD = require('plenary.reload').reload_module

    R = function(name)
        RELOAD(name)
        return require(name)
    end
end
