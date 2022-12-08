local M = {}

M.setup = function(name, config)
    return not config and string.format([[require('%s').setup()]], name)
        or string.format([[require('%s').setup(%s)]], name, vim.inspect(config or {}))
end

M.conf = function(name)
    return string.format([[require('config.%s')]], name)
end

local opt_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if not vim.loop.fs_stat(opt_path) then
    vim.fn.execute('!git clone https://github.com/lewis/packer.nvim --branch=main ' .. opt_path)
end

vim.cmd.packadd('packer.nvim')

require('packer').setup({
    config = {
        display = {
            prompt_border = CUSTOM_BORDER,
        },
    },
})

M.add = function(init)
    for k, val in ipairs(init) do
        local plugin = type(val) == 'table' and val[1] or val
        local author, name = unpack(vim.split(plugin, '/'))
        local install_path = string.format('%s/projects/plugins/%s', os.getenv('HOME'), name)
        if author == 'seblj' and vim.loop.fs_stat(install_path) then
            if type(val) == 'table' then
                val[1] = install_path
            else
                init[k] = install_path
            end
        end
    end

    require('packer').add(init)
end

return M
