---------- FILE EXPLORER CONFIG ----------

local actions = require('lir.actions')

require('nvim-web-devicons').setup({
    default = true,
    override = {
        lir_folder_icon = {
            icon = '',
            color = '#7ebae4',
            name = 'LirFolderNode',
        },
    },
})

local lir = require('lir')
local utils = require('lir.utils')
local Path = require('plenary.path')
lir.setup({
    show_hidden_files = true,
    devicons_enable = true,

    mappings = {
        ['<C-x>'] = actions.split,
        ['<C-v>'] = actions.vsplit,
        ['<C-t>'] = actions.tabedit,
        ['<CR>'] = actions.edit,
        ['..'] = actions.up,
        ['N'] = function()
            vim.ui.input({ prompt = 'New file: ' }, function(name)
                if name == nil then
                    return
                end
                local path = Path:new(lir.get_context().dir .. name)
                path:touch({
                    parents = true,
                    mode = tonumber('644', 8),
                })

                actions.reload()
            end)
        end,
        ['M'] = function()
            vim.ui.input({ prompt = 'New directory: ' }, function(name)
                if name == nil then
                    return
                end

                if name == '.' or name == '..' then
                    utils.error('Invalid directory name: ' .. name)
                    return
                end

                local ctx = lir.get_context()
                local path = Path:new(ctx.dir .. name)
                if path:exists() then
                    utils.error('Directory already exists')
                    -- cursor jump
                    local lnum = ctx:indexof(name)
                    if lnum then
                        vim.cmd(tostring(lnum))
                    end
                    return
                end

                path:mkdir({ parents = true })
                actions.reload()
                vim.schedule(function()
                    local lnum = lir.get_context():indexof(name)
                    if lnum then
                        vim.cmd(tostring(lnum))
                    end
                end)
            end)
        end,
        ['r'] = function()
            local ctx = lir.get_context()
            local old = string.gsub(ctx:current_value(), Path.path.sep .. '$', '')
            vim.ui.input({ prompt = 'Rename: ' }, function(new)
                if new == nil or new == old then
                    return
                end

                if new == '.' or new == '..' or string.match(new, '[/\\]') then
                    utils.error('Invalid name: ' .. new)
                    return
                end

                if not vim.loop.fs_rename(ctx.dir .. old, ctx.dir .. new) then
                    utils.error('Rename failed')
                end

                actions.reload()
            end)
        end,
        ['Y'] = actions.yank_path,
        ['dd'] = actions.delete,
    },
    hide_cursor = true,
})
