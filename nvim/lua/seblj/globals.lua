P = function(...)
    vim.print(...)
end

COLORSCHEME = "colorscheme"
CUSTOM_BORDER = vim.uv.os_uname().sysname == "Windows_NT" and "single"
    or { "", "", "", "", "", "", "", "" }

-- Override vim.keymap.set to have silent as default
local map = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = vim.deepcopy(opts) or {}
    if opts.silent == nil then
        opts.silent = true
    end
    map(mode, lhs, rhs, opts)
end
