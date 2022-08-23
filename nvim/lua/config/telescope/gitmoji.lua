local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')
local utils = require('telescope.utils')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local Path = require('plenary.path')

local function gen_from_gitmoji(opts)
    local displayer = require('telescope.pickers.entry_display').create({
        separator = '▏',
        items = {
            { width = 3 },
            { width = 28 },
            { remaining = true },
        },
    })
    local make_display = function(entry)
        return displayer({
            entry.emoji,
            entry.word,
            entry.desc,
        })
    end

    return function(entry)
        return make_entry.set_default_entry_mt({
            emoji = entry.emoji,
            word = entry.code,
            desc = entry.desc,
            ordinal = entry.code .. ' ' .. entry.desc,
            display = make_display,
            value = entry.code,
        }, opts)
    end
end

local function gitmoji(opts)
    opts = opts or {}
    local gitmojis = vim.json.decode(Path:new('~/dotfiles/nvim/lua/config/telescope/gitmoji.json'):read())
    local results = {}
    for _, v in pairs(gitmojis) do
        table.insert(results, { emoji = v.emoji, code = v.code, desc = v.description })
    end
    pickers.new(opts, {
        prompt_title = 'Gitmoji',
        finder = finders.new_table({
            results = results,
            entry_maker = gen_from_gitmoji(opts),
        }),
        sorter = conf.generic_sorter(opts),
        -- attach_mappings = function()
        --     actions.select_default:replace(function(prompt_bufnr)
        --         local selection = action_state.get_selected_entry()
        --         if selection == nil then
        --             utils.__warn_no_selection('actions.insert_value')
        --             return
        --         end

        --         vim.schedule(function()
        --             actions.close(prompt_bufnr)
        --         end)
        --         return selection.word
        --     end)
        --     return true
        -- end,
    }):find()
end

gitmoji()
