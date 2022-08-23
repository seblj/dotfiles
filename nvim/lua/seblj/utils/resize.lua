---------- RESIZE SPLITS ----------

-- https://github.com/ahonn/resize.vim/blob/master/plugin/resize.vim rewritten in lua
local M = {}

local resize_size = 1

local pos_size = '+' .. resize_size
local neg_size = '-' .. resize_size

local get_direction = function(pos)
    local this = vim.fn.winnr()
    vim.cmd.wincmd(pos)
    local next = vim.fn.winnr()
    vim.cmd.wincmd({ 'w', count = this })
    return this == next
end

local is_bottom_window = function()
    return get_direction('j') and not get_direction('k')
end

local is_right_window = function()
    return get_direction('l') and not get_direction('h')
end

M.resize_up = function()
    return vim.cmd.resize(is_bottom_window() and pos_size or neg_size)
end

M.resize_down = function()
    return vim.cmd.resize(is_bottom_window() and neg_size or pos_size)
end

M.resize_left = function()
    return vim.cmd.resize({ is_right_window() and pos_size or neg_size, mods = { vertical = true } })
end

M.resize_right = function()
    return vim.cmd.resize({ is_right_window() and neg_size or pos_size, mods = { vertical = true } })
end

return M
