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

require('lazy.view').hover = 'gd'

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
        require(string.format('config.%s', name))
    end
end

return M
