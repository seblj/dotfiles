vim.notify = require('notify')
require('notify').setup({
    on_open = function(win)
        -- Don't like when it shows after packer sync and blocks the
        -- commits from plugins. So print normal if ft is packer
        local ft = vim.api.nvim_buf_get_option(0, 'ft')
        if ft == 'packer' then
            vim.api.nvim_win_close(win, true)
            local history = require('notify').history()
            local last = history[#history]
            print(unpack(last.message))
        end
    end,
})
