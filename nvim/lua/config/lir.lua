---------- FILE EXPLORER CONFIG ----------

local actions = require('lir.actions')
local keymap = vim.keymap.set

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

local new_file = function()
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
end

local new_directory = function()
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
end

local rename = function()
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
end

lir.setup({
    show_hidden_files = true,
    devicons_enable = true,
    hide_cursor = true,
    on_init = function()
        keymap('n', '<C-x>', actions.split, { buffer = true, desc = 'Lir: Open horizontal split' })
        keymap('n', '<C-v>', actions.vsplit, { buffer = true, desc = 'Lir: Open vertical split' })
        keymap('n', '<C-t>', actions.tabedit, { buffer = true, desc = 'Lir: Open new tab' })
        keymap('n', '<CR>', actions.edit, { buffer = true, desc = 'Lir: Open file' })
        keymap('n', '..', actions.up, { buffer = true, desc = 'Lir: Go one directory up' })
        keymap('n', 'Y', actions.yank_path, { buffer = true, desc = 'Lir: Yank path' })
        keymap('n', 'dd', actions.delete, { buffer = true, desc = 'Lir: Delete' })
        keymap('n', 'N', new_file, { buffer = true, desc = 'Lir: Create new file' })
        keymap('n', 'M', new_directory, { buffer = true, desc = 'Lir: Create new directory' })
        keymap('n', 'r', rename, { buffer = true, desc = 'Lir: Rename' })
    end,
})
