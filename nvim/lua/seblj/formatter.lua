-- Inspiration from https://github.com/mhartington/formatter.nvim but
local Job = require('plenary.job')
local notify_opts = { title = 'Formatter' }

local config = {}

-- Workaround to save and restore marks before calling vim.api.nvim_buf_set_lines
-- Ideally I would want to implement a diff that could calculate all the changes
-- on lines and characters, and use vim.lsp.util.apply_text_edits
local function save_marks(bufnr)
    local marks = {}
    for _, m in pairs(vim.fn.getmarklist(bufnr)) do
        if m.mark:match("^'[a-z]$") then
            marks[m.mark] = m.pos
        end
    end
    return marks
end

local function restore_marks(bufnr, marks)
    for _, m in pairs(vim.fn.getmarklist(bufnr)) do
        marks[m.mark] = nil
    end

    for mark, pos in pairs(marks) do
        if pos then
            vim.fn.setpos(mark, pos)
        end
    end
end

local M = {}

function M.setup(user_config)
    config = user_config
    vim.api.nvim_create_user_command('Format', function(c_opts)
        M.format(c_opts.line1, c_opts.line2)
    end, {
        range = '%',
        bar = true,
    })
end

function M.format(start_line, end_line, opts)
    if not vim.bo.modifiable then
        return vim.notify('Buffer is not modifiable', vim.log.levels.INFO, notify_opts)
    end

    local f = config.filetype[vim.bo.filetype]
    local conf = f and f() or nil
    if not conf then
        return vim.notify(
            string.format('No formatter defined for: %s', vim.bo.filetype),
            vim.log.levels.ERROR,
            notify_opts
        )
    end
    if conf.cond and not conf.cond() then
        return
    end

    opts = vim.tbl_deep_extend('keep', opts or {}, { write = false })
    local bufnr = vim.api.nvim_get_current_buf()
    local input = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, true)
    Job:new({
        command = conf.exe,
        args = conf.args or {},
        cwd = conf.cwd or vim.loop.cwd(),
        writer = input,
        on_exit = function(j, exit_code)
            if exit_code ~= 0 then
                vim.notify(
                    string.format('Failed to format: %s', table.concat(j:stderr_result())),
                    vim.log.levels.ERROR,
                    notify_opts
                )
            else
                local output = j:result()
                if not vim.deep_equal(input, output) then
                    -- TODO: Future improvements could be to calculate the diff
                    -- between input and output, and use nvim_buf_set_text
                    vim.schedule(function()
                        local view = vim.fn.winsaveview()
                        local marks = save_marks(bufnr)
                        vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, output)
                        vim.cmd.write({ mods = { emsg_silent = true, silent = true } })
                        vim.fn.winrestview(view)
                        restore_marks(bufnr, marks)
                    end)
                end
            end
        end,
    }):sync()
end

return M
