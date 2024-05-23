vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        -- Conditions where I don't want to do stuff
        if vim.env.SSH_CONNECTION or vim.env.TERM ~= "xterm-kitty" then
            return
        end

        local neovim_bg = string.format("#%x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg)
        vim.system({ "kitty", "@", "get-colors" }, {}, function(obj)
            local color = vim.iter(vim.split(obj.stdout, "\n")):find(function(v)
                return string.match(v, "^background")
            end)
            color = color and vim.split(color, "%s+")[2] or "#1c1c1c"

            if string.lower(color) == string.lower(neovim_bg) then
                return
            end

            vim.system({ "kitty", "@", "set-colors", string.format("background=%s", neovim_bg) })
            vim.system({ "kitty", "@", "set-colors", string.format("active_tab_background=%s", neovim_bg) })
            vim.system({ "kitty", "@", "set-colors", string.format("inactive_tab_background=%s", neovim_bg) })

            local filename = vim.fs.normalize("~/dotfiles/kitty/kitty-theme.conf")
            vim.system({ "cat", filename }, {}, function(_obj)
                local out = _obj.stdout:gsub(color, neovim_bg)
                local file = io.open(filename, "w")
                if not file then
                    return
                end
                file:write(out)
                file:close()
            end)
        end)
    end,
})
