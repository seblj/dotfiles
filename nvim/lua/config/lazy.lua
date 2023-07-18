---------- LAZY ----------

local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }):wait()
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

function M.setup(config)
    require("lazy.view.config").keys.hover = "gh"
    require("lazy").setup(config, {
        dev = {
            path = string.format("%s/projects/plugins", os.getenv("HOME")),
            fallback = true,
        },
        ui = {
            border = CUSTOM_BORDER,
        },
        install = {
            colorscheme = { COLORSCHEME },
        },
    })
end

return M
