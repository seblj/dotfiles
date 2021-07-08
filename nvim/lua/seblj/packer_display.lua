local M = {}

M.packer_prompt = function(headline, body, callback)
    local buf = vim.api.nvim_create_buf(false, true)
    local longest_line = 0
    for _, line in ipairs(body) do
        local line_length = string.len(line)
        if line_length > longest_line then
            longest_line = line_length
        end
    end

    local width = math.min(longest_line + 2, math.floor(0.9 * vim.o.columns))
    local height = #body + 3
    local x = (vim.o.columns - width) / 2.0
    local y = (vim.o.lines - height) / 2.0
    local pad_width = math.max(math.floor((width - string.len(headline)) / 2.0), 0)
    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        true,
        vim.list_extend({
            string.rep(' ', pad_width) .. headline .. string.rep(' ', pad_width),
            '',
        }, body)
    )
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = x,
        row = y,
        focusable = false,
        style = 'minimal',
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        noautocmd = true,
    }

    local win = vim.api.nvim_open_win(buf, false, opts)
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal')
    local check = vim.loop.new_prepare()
    local prompted = false
    vim.loop.prepare_start(
        check,
        vim.schedule_wrap(function()
            if not vim.api.nvim_win_is_valid(win) then
                return
            end
            vim.loop.prepare_stop(check)
            if not prompted then
                prompted = true
                local ans = string.lower(vim.fn.input('OK to remove? [y/N] ')) == 'y'
                vim.api.nvim_win_close(win, true)
                callback(ans)
            end
        end)
    )
end

return M
