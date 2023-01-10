local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

function M.conf(name)
    return function()
        local c = require(string.format("config.%s", name))
        if type(c) == "table" and c.config then
            c.config()
        end
    end
end

function M.init(name)
    return function()
        require(string.format("config.%s", name)).init()
    end
end

local function walk_spec(config)
    for k, val in ipairs(config) do
        local plugin = type(val) == "table" and val[1] or val
        local author, name = unpack(vim.split(plugin, "/"))
        local install_path = string.format("%s/projects/plugins/%s", os.getenv("HOME"), name)
        if val.dependencies then
            walk_spec(val.dependencies)
        end
        if author == "seblj" and vim.loop.fs_stat(install_path) then
            if type(val) == "table" then
                val.dev = true
            else
                config[k] = { val, dev = true }
            end
        end
    end
end

function M.setup(config)
    walk_spec(config)
    require("lazy").setup(config, {
        dev = {
            path = "~/projects/plugins",
        },
        ui = {
            border = CUSTOM_BORDER,
        },
    })
end

return M
