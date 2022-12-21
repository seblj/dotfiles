local M = {}

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

M.setup = function(name, config)
    return function()
        if config then
            require(name).setup(config)
        else
            require(name).setup()
        end
    end
end

M.conf = function(name)
    return function()
        local c = require(string.format('config.%s', name))
        if type(c) == 'table' and c.config then
            c.config()
        end
    end
end

M.init = function(name)
    return function()
        require(string.format('config.%s', name)).init()
    end
end

M.lazy_setup = function(config)
    for k, val in ipairs(config) do
        local plugin = type(val) == 'table' and val[1] or val
        local author, name = unpack(vim.split(plugin, '/'))
        local install_path = string.format('%s/projects/plugins/%s', os.getenv('HOME'), name)
        if author == 'seblj' and vim.loop.fs_stat(install_path) then
            if type(val) == 'table' then
                val.dev = true
            else
                config[k] = { val, dev = true }
            end
        end
    end

    require('lazy').setup(config, {
        dev = {
            path = '~/projects/plugins',
        },
        ui = {
            border = CUSTOM_BORDER,
        },
    })
end

return M
