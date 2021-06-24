-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals/init.lua

Loaded_colorscheme = false

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

-- Set OS to global variable
if vim.fn.system('uname') == 'Linux\n' then
    OS = 'Linux'
elseif vim.fn.system('uname') == 'Darwin\n' then
    OS = 'Mac'
end
