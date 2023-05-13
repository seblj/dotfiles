---------- UTILS ----------

local M = {}

---@class TermConfig
---@field direction "new" | "vnew" | "tabnew"
---@field cmd string
---@field new boolean
---@field focus boolean
---@param opts TermConfig
function M.term(opts, ...)
    local terminal = vim.iter(vim.fn.getwininfo()):find(function(v)
        return v.terminal == 1
    end)
    if terminal and not opts.new then
        return vim.api.nvim_chan_send(vim.b[terminal.bufnr].terminal_job_id, string.format(opts.cmd .. "\n", ...))
    end

    local current_win = vim.api.nvim_get_current_win()
    local size = math.floor(vim.api.nvim_win_get_height(0) / 3)
    vim.cmd[opts.direction]({ range = opts.direction == "new" and { size } or { nil } })
    local term = vim.fn.termopen(vim.env.SHELL) --[[@as number]]
    if not opts.focus then
        vim.cmd.stopinsert()
        vim.api.nvim_set_current_win(current_win)
    end
    vim.api.nvim_chan_send(term, string.format(opts.cmd .. "\n", ...))
end

function M.get_os_command_output(command, opts)
    opts = opts or {}
    opts.command = command
    opts.cwd = opts.cwd or vim.loop.cwd()
    return require("plenary.job"):new(opts):sync()
end

function M.get_zsh_completion(args, prefix)
    return vim.iter.map(function(v)
        local val = vim.fn.split(v, " -- ")[1]
        return prefix and string.format("%s%s", prefix, val) or val
    end, M.get_os_command_output("capture", { args = { args } }))
end

---Tries to find root_dir pattern for a buffer autocmd. Fallback to <buffer> if
---root_dir is not found
local function get_root_dir_pattern()
    local active_clients = vim.lsp.get_active_clients()
    if #active_clients > 0 and active_clients[1].config then
        local root_dir = active_clients[1].config.root_dir
        if root_dir and root_dir ~= vim.env.HOME then
            return string.format("%s/*", root_dir)
        end
    end
    return "<buffer>"
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

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("RunOnSave", { clear = true }),
        pattern = get_root_dir_pattern(),
        callback = function()
            vim.schedule(function()
                if opts.args:sub(1, 1) == "!" then
                    M.term({ direction = "new", focus = false, cmd = string.sub(opts.args, 2) })
                else
                    local this = vim.fn.winnr()
                    vim.cmd(opts.args)
                    vim.cmd.wincmd({ "w", count = this })
                end
            end)
        end,
        desc = "Run command on save",
    })
end, {
    nargs = "*",
    bang = true,
    complete = function(arg_lead, cmdline, _)
        local command = vim.split(cmdline, "RunOnSave ")[2]
        if command:sub(1, 1) == "!" then
            vim.cmd.lcd(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
            return M.get_zsh_completion(string.sub(command, 2), arg_lead:sub(1, 1) == "!" and "!" or nil)
        else
            return vim.fn.getcompletion(command, "cmdline")
        end
    end,
})

local runner = {
    python = "python3 $file",
    c = "gcc $file -o $output && ./$output; rm $output",
    javascript = "node $file",
    typescript = "ts-node $file",
    rust = function()
        local command = "rustc $file && ./$output; rm $output"
        local match = vim.fn.system("cargo verify-project"):match('{"success":"true"}')
        return match and "cargo run" or command
    end,
    go = function()
        local command = "go run $file"
        local dir = vim.fs.dirname(vim.fs.find("go.mod", { upward = true })[1])
        return dir and "go run " .. dir or command
    end,
    sh = "sh $file",
}

-- Save and execute file based on filetype
function M.save_and_exec()
    local ft = vim.bo.filetype
    vim.cmd.write({ mods = { emsg_silent = true, noautocmd = true } })
    vim.api.nvim_echo({ { "Executing file" } }, false, {})
    if ft == "vim" or ft == "lua" then
        vim.cmd.source("%")
    elseif ft == "http" then
        -- Not really save and exec, but think it fits nicely in here for mapping
        require("rest-nvim").run()
    else
        local file = vim.api.nvim_buf_get_name(0)
        vim.cmd.lcd(vim.fs.dirname(file))
        local command = type(runner[ft]) == "function" and runner[ft]() or runner[ft]
        if not command then
            return vim.notify(
                string.format("No config found for %s", ft),
                vim.log.levels.INFO,
                { title = "Save and exec" }
            )
        end

        local output = vim.fn.fnamemodify(file, ":t:r")
        command = command:gsub("$file", file):gsub("$output", output)
        M.term({ direction = "new", focus = false, cmd = command })
    end
end

---------- HIDE CURSOR ----------

-- https://github.com/tamago324/lir.nvim/blob/master/lua/lir/smart_cursor/init.lua

local guicursor_saved = vim.opt.guicursor

local function hide_cursor()
    vim.opt.guicursor = vim.opt.guicursor + "a:CursorTransparent/lCursor"
end

function M.setup_hidden_cursor(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    hide_cursor()
    vim.opt_local.cursorline = true
    vim.opt_local.winhighlight = "CursorLine:CursorLineHiddenCursor"

    local group = vim.api.nvim_create_augroup("HiddenCursor", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CmdwinLeave", "CmdlineLeave" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            hide_cursor()
            vim.opt_local.cursorline = true
            vim.opt_local.winhighlight = "CursorLine:CursorLineHiddenCursor"
        end,
        desc = "Hide cursor",
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "CmdwinEnter", "CmdlineEnter" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            vim.schedule(function()
                vim.opt.guicursor = vim.opt.guicursor + "a:Cursor/lCursor"
                vim.opt.guicursor = guicursor_saved
                vim.opt_local.cursorline = false
            end)
        end,
        desc = "Show cursor",
    })
end

return M
