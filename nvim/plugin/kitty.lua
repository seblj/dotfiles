local eval = vim.api.nvim_eval
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Make kitty distinguish between <C-i> and <Tab>
if vim.env.TERM == "xterm-kitty" then
    local group = augroup("KittyFix", {})
    local function kitty_fix(s)
        if eval("v:event.chan") == 0 then
            vim.fn["chansend"](eval("v:stderr"), s)
        end
    end
    autocmd("UIEnter", {
        group = group,
        pattern = "*",
        callback = function()
            kitty_fix("\x1b[>1u")
        end,
        desc = "Fix kitty",
    })
    autocmd("UILeave", {
        group = group,
        pattern = "*",
        callback = function()
            kitty_fix("\x1b[<1u")
        end,
        desc = "Fix kitty",
    })
end
