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
    vim.cmd(string.format('%s wincmd w', this))
    return this == next
end

local is_bottom_window = function()
    local is_top = get_direction('k')
    local is_bottom = get_direction('j')
    return is_bottom and not is_top
end

local is_right_window = function()
    local is_left = get_direction('h')
    local is_right = get_direction('l')
    return is_right and not is_left
end

local resize_vertical = function(size)
    vim.cmd.resize({ size, mods = { vertical = true } })
end

local resize_horizontal = function(size)
    vim.cmd.resize(size)
end

M.resize_up = function()
    if is_bottom_window() then
        return resize_horizontal(pos_size)
    end
    return resize_horizontal(neg_size)
end

M.resize_down = function()
    if is_bottom_window() then
        return resize_horizontal(neg_size)
    end
    return resize_horizontal(pos_size)
end

M.resize_left = function()
    if is_right_window() then
        return resize_vertical(pos_size)
    end
    return resize_vertical(neg_size)
end

M.resize_right = function()
    if is_right_window() then
        return resize_vertical(neg_size)
    end
    return resize_vertical(pos_size)
end

return M
