-- Make kitty distinguish between <C-i> and <Tab>
if vim.env.TERM == "xterm-kitty" then
    vim.api.nvim_create_autocmd({ "UIEnter", "UILeave" }, {
        group = vim.api.nvim_create_augroup("KittyFix", { clear = true }),
        pattern = "*",
        callback = function(au)
            if vim.v.event == 0 then
                io.stderr:write(au.event == "UIEnter" and "\x1b[>1u" or "\x1b[<1u")
            end
        end,
        desc = "Fix kitty",
    })
end
