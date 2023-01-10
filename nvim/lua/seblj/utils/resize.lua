---------- RESIZE SPLITS ----------

-- https://github.com/ahonn/resize.vim/blob/master/plugin/resize.vim rewritten in lua
local M = {}

local resize_size = 1

local pos_size = "+" .. resize_size
local neg_size = "-" .. resize_size

local function get_direction(pos)
    local this = vim.fn.winnr()
    vim.cmd.wincmd(pos)
    local next = vim.fn.winnr()
    vim.cmd.wincmd({ "w", count = this })
    return this == next
end

local function is_bottom_window()
    return get_direction("j") and not get_direction("k")
end

local function is_right_window()
    return get_direction("l") and not get_direction("h")
end

function M.resize_up()
    return vim.cmd.resize(is_bottom_window() and pos_size or neg_size)
end

function M.resize_down()
    return vim.cmd.resize(is_bottom_window() and neg_size or pos_size)
end

function M.resize_left()
    return vim.cmd.resize({ is_right_window() and pos_size or neg_size, mods = { vertical = true } })
end

function M.resize_right()
    return vim.cmd.resize({ is_right_window() and neg_size or pos_size, mods = { vertical = true } })
end

return M
