local branch = vim.system({ "git", "branch", "--show-current" }):wait().stdout:gsub("\n", "")
if vim.regex([[\(chore\|bug\|story\)-\d\{4,5}]]):match_str(branch) then
    branch = "[#" .. branch:gsub(".*%-", "") .. "]"
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { branch .. " " })
    -- nvim_buf_set_lines creates a new line for some reason so delete it
    vim.cmd.normal({ "2Gdd" })
    vim.api.nvim_win_set_cursor(0, { 1, #branch })
end
