-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/stylua.lua
local Path = require('plenary.path')
local Job = require('plenary.job')

local scan = require('plenary.scandir')

local root_pattern
root_pattern = function(start, pattern)
    if start == '/' then return nil end
    local res = scan.scan_dir(start, { search_pattern = pattern, hidden = true, add_dirs = true, depth = 1 })
    if table.getn(res) == 0 then
        local new = start .. '/../'
        return root_pattern(vim.loop.fs_realpath(new), pattern)
    else
        return start
    end
end

local cached_configs = {}

local stylua_finder = function(path)
    if cached_configs[path] == nil then
        local file_path = Path:new(path)
        local root_path = Path:new(root_pattern(path, '/%.git$'))

        local file_parents = file_path:parents()
        local root_parents = root_path:parents()

        local relative_diff = #file_parents - #root_parents
        for index, dir in ipairs(file_parents) do
            if index > relative_diff then
                break
            end

            local stylua_path = Path:new({ dir, 'stylua.toml' })
            local dot_stylua_path = Path:new({ dir, '.stylua.toml' })

            if stylua_path:exists() then
                cached_configs[path] = stylua_path:absolute()
                break
            end
            if dot_stylua_path:exists() then
                cached_configs[path] = dot_stylua_path:absolute()
                break
            end
        end
    end

    return cached_configs[path]
end

local stylua = {}

stylua.format = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local filepath = Path:new(vim.api.nvim_buf_get_name(bufnr)):absolute()
    local stylua_toml = stylua_finder(filepath)

    if not stylua_toml then
        return
    end

    -- stylua: ignore
    local j = Job:new {
        "stylua",
        "--config-path", stylua_toml,
        "-",
        writer = vim.api.nvim_buf_get_lines(0, 0, -1, false),
    }

    local output = j:sync()

    if j.code ~= 0 then
        -- Schedule this so that it doesn't do dumb stuff like printing two things.
        vim.schedule(function()
            print('[stylua] Failed to process due to errors')
        end)

        return
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
end

return stylua
