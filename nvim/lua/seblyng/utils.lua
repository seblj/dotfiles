---------- UTILS ----------

local M = {}

---@class TermConfig
---@field direction "new" | "vnew" | "tabnew"
---@field cmd string
---@field new? boolean
---@field focus boolean
---@param opts TermConfig
function M.term(opts, ...)
    local terminal = vim.iter(vim.fn.getwininfo()):find(function(v)
        return v.terminal == 1
    end)
    if terminal and not opts.new then
        vim.api.nvim_buf_call(terminal.bufnr, function()
            vim.cmd("$")
        end)
        return vim.api.nvim_chan_send(vim.bo[terminal.bufnr].channel, string.format(opts.cmd .. "\n", ...))
    end

    local current_win = vim.api.nvim_get_current_win()
    local size = math.floor(vim.api.nvim_win_get_height(0) / 3)
    vim.cmd[opts.direction]({ range = opts.direction == "new" and { size } or { nil } })
    local term = vim.fn.jobstart(vim.env.SHELL, { term = true })
    if not opts.focus then
        vim.cmd.stopinsert()
        vim.api.nvim_set_current_win(current_win)
    end
    if opts.cmd and opts.cmd ~= "" then
        vim.api.nvim_chan_send(term, string.format(opts.cmd .. "\n", ...))
    end
end

---@param fn function
---@param dir? string
function M.wrap_lcd(fn, dir)
    local current_cwd = vim.uv.cwd()
    local _dir = dir or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    vim.cmd.lcd({ args = { _dir }, mods = { silent = true } })
    local ret = fn()
    vim.cmd.lcd({ args = { current_cwd }, mods = { silent = true } })
    return ret
end

function M.get_zsh_completion(args, prefix)
    return vim.iter(vim.split(vim.trim(vim.system({ "capture", args }, { text = true }):wait().stdout), "\n"))
        :map(function(v)
            local val = vim.fn.split(v, " -- ")[1]
            return prefix and string.format("%s%s", prefix, val) or val
        end)
        :totable()
end

-- Creates a user_command to run a command each time a buffer is saved. By
-- default it will try to find the root of the current buffer using LSP, and run
-- the command on save for all files in the project.
--
-- To run a shell-command, prefix the arguments to `RunOnSave` with `!`.
-- For example: `RunOnSave !cat foo.txt`.
-- To run a vim-command, don't prefix with `!`.
-- For example: `RunOnSave lua print("foo")`
vim.api.nvim_create_user_command("RunOnSave", function(opts)
    -- Create a user_command to clear only if we create an autocmd to run on save
    vim.api.nvim_create_user_command("RunOnSaveClear", function()
        vim.api.nvim_clear_autocmds({ group = "RunOnSave" })
        vim.api.nvim_del_user_command("RunOnSaveClear")
    end, { bang = true })

    local function get_root_dir_pattern()
        local root = vim.fs.root(0, ".git")
        return root and string.format("%s/*", root) or "<buffer>"
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("RunOnSave", { clear = true }),
        pattern = get_root_dir_pattern(),
        callback = function()
            vim.schedule(function()
                M.wrap_lcd(function()
                    if opts.args:sub(1, 1) == "!" then
                        M.term({ direction = "new", focus = false, cmd = string.sub(opts.args, 2) })
                    else
                        local this = vim.fn.winnr()
                        vim.cmd(opts.args)
                        vim.cmd.wincmd({ "w", count = this })
                    end
                end)
            end)
        end,
        desc = "Run command on save",
    })
end, {
    nargs = "*",
    bang = true,
    complete = function(arg_lead, cmdline, _)
        return M.wrap_lcd(function()
            local command = vim.split(cmdline, "RunOnSave ")[2]
            if command:sub(1, 1) == "!" then
                return M.get_zsh_completion(string.sub(command, 2), arg_lead:sub(1, 1) == "!" and "!" or nil)
            else
                return vim.fn.getcompletion(command, "cmdline")
            end
        end)
    end,
})

local runner = {
    typst = "typst compile $file",
    lua = ":source %",
    vim = ":source %",
    python = "python3 $file",
    c = "gcc $file -o $output && ./$output; rm $output",
    javascript = "bun $file",
    typescript = "bun $file",
    rust = function()
        local command = "rustc $file && ./$output; rm $output"
        local match = vim.system({ "cargo", "verify-project" }):wait().stdout:match('{"success":"true"}')
        return match and "cargo run" or command
    end,
    go = function()
        local command = "go run $file"
        local dir = vim.fs.root(0, { "go.mod" })
        return dir and "go run " .. dir or command
    end,
    sh = "sh $file",
    http = function(file)
        if string.match(file, "mobileapi/login.http") then
            return "hitman -t master $file"
        else
            return "hitman $file"
        end
    end,
    graphql = "hitman $file",
}

-- Save and execute file based on filetype
function M.save_and_exec()
    local ft = vim.bo.filetype
    vim.cmd.write({ mods = { emsg_silent = true, noautocmd = true } })
    vim.notify("Executing file")
    local file = vim.api.nvim_buf_get_name(0)
    M.wrap_lcd(function()
        local command = type(runner[ft]) == "function" and runner[ft](file) or runner[ft]
        if not command then
            return vim.notify(string.format("No config found for %s", ft))
        end

        local output = vim.fn.fnamemodify(file, ":t:r") --[[@as string]]
        command = command:gsub("$file", file):gsub("$output", output)
        if command:sub(1, 1) == ":" then
            vim.cmd(command)
        else
            M.term({ direction = "new", focus = false, cmd = command })
        end
    end)
end

---------- HIDE CURSOR ----------

-- https://github.com/tamago324/lir.nvim/blob/master/lua/lir/smart_cursor/init.lua

local guicursor_saved = vim.opt.guicursor

function M.setup_hidden_cursor()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_hl(0, "CursorTransparent", { strikethrough = true, blend = 100 })
    vim.opt.guicursor = vim.opt.guicursor + "a:CursorTransparent/lCursor"
    vim.wo[0][0].cursorline = true
    vim.wo[0][0].winhighlight = "CursorLine:Error"

    local group = vim.api.nvim_create_augroup("HiddenCursor", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CmdwinLeave", "CmdlineLeave" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            vim.opt.guicursor = vim.opt.guicursor + "a:CursorTransparent/lCursor"
        end,
        desc = "Hide cursor",
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "CmdwinEnter", "CmdlineEnter" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            vim.schedule(function()
                vim.opt.guicursor = guicursor_saved
            end)
        end,
        desc = "Show cursor",
    })
end

return M
