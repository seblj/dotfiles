local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Automatically insert #1234 in commit if name of git branch is for example: `story-1234`
local group = augroup('GitStoryCommit', {})
autocmd('FileType', {
    group = group,
    pattern = 'gitcommit',
    callback = function()
        local branch = vim.fn.system('git branch --show-current'):gsub('\n', '')
        if branch:match('story%-%d.+') then
            branch = '[#' .. branch:gsub('story%-', '') .. ']'
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { branch })
            -- nvim_buf_set_lines creates a new line for some reason so delete it
            vim.cmd([[norm! 2Gdd]])
            vim.api.nvim_win_set_cursor(0, { 1, #branch })
        end
    end,
})
