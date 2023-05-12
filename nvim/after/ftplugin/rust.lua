vim.api.nvim_create_user_command("Cargo", function(x)
    vim.cmd.compiler("cargo")
    local root_file = vim.fs.find({ "Cargo.toml" }, {
        stop = vim.loop.os_homedir(),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        upward = true,
    })[1]
    vim.cmd.lcd(vim.fs.dirname(root_file))
    vim.cmd.make({ x.args, bang = true, mods = { silent = true } })
    local errors, warnings = 0, 0
    for _, val in pairs(vim.fn.getqflist()) do
        if val.type == "E" then
            errors = errors + 1
        elseif val.type == "W" and not string.match(val.text, "generated %d warning") then
            warnings = warnings + 1
        end
    end
    -- Shuts up hit enter to continue prompt
    vim.cmd.redraw()
    vim.api.nvim_echo({ { string.format("E: %s | W: %s", errors, warnings) } }, false, {})
    if warnings ~= 0 or errors ~= 0 then
        vim.cmd.copen()
        vim.bo.filetype = "rust-qf"
    end
end, {
    nargs = "*",
    complete = function()
        return { "clippy", "build", "check" }
    end,
})
