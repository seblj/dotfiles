local Path = require('plenary.path')

local gitmoji = function(text, emoji)
    vim.cmd.substitute({
        string.format('/%s/%s/gI', text, emoji),
        range = { 1, vim.api.nvim_buf_line_count(0) },
        mods = { emsg_silent = true },
    })
end

vim.bo.modifiable = true
local gitmojis = vim.json.decode(Path:new('~/dotfiles/nvim/lua/config/telescope/gitmoji.json'):read())
for _, v in pairs(gitmojis) do
    gitmoji(v.code, v.emoji)
end
vim.bo.modifiable = false
