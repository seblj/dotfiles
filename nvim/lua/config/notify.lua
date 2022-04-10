vim.notify = require('notify')

require('notify').setup({
    minimum_width = math.floor(vim.api.nvim_get_option('columns') / 3),
    max_width = math.floor(vim.api.nvim_get_option('columns') / 3),
    on_open = function(win)
        vim.api.nvim_win_set_option(win, 'wrap', true)
        -- Don't like when it shows after packer sync and blocks the
        -- commits from plugins. So print normal if ft is packer
        local ft = vim.api.nvim_buf_get_option(0, 'ft')
        if ft == 'packer' then
            vim.api.nvim_win_close(win, true)
            local history = require('notify').history()
            local last = history[#history]
            print(unpack(last.message))
        end
        -- Hopefully less annoying interrupts from rust_analyzer
        if ft == 'rust' then
            local history = require('notify').history()
            local last = history[#history]
            if string.match(unpack(last.message), 'rust_analyzer') then
                vim.api.nvim_win_close(win, true)
                print(unpack(last.message))
            end
        end
    end,
})
