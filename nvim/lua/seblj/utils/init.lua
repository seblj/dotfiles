---------- UTILS ----------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

---@class TermConfig
---@field direction "split" | "vsplit" | "tabnew"
---@field cmd string
---@field new boolean
---@field focus boolean
---@param opts TermConfig
function M.term(opts, ...)
    local terminal = vim.fn.filter(vim.fn.getwininfo(), "v:val.terminal")[1]
    if not terminal or opts.new then
        local current_win = vim.api.nvim_get_current_win()
        local height = vim.api.nvim_win_get_height(0)
        vim.cmd[opts.direction]()
        if opts.direction == "split" then
            vim.api.nvim_win_set_height(0, math.floor(height / 3))
        end
        vim.cmd.term()
        vim.cmd("$")
        terminal = vim.fn.filter(vim.fn.getwininfo(), "v:val.terminal")[1]
        if not opts.focus then
            vim.cmd.stopinsert()
            vim.api.nvim_set_current_win(current_win)
        end
    end
    vim.api.nvim_chan_send(vim.b[terminal.bufnr].terminal_job_id, string.format(opts.cmd .. "\n", ...))
end

function M.get_os_command_output(command, opts)
    local res
    opts = opts or {}
    opts.command = command
    opts.cwd = opts.cwd or vim.loop.cwd()
    opts.args = opts.args or {}
    opts.on_exit = function(j)
        res = j:result()
    end
    require("plenary.job"):new(opts):sync()
    return res
end

function M.get_zsh_completion(args)
    local completions = M.get_os_command_output("capture", { args = { args } })
    for k, v in ipairs(completions) do
        completions[k] = vim.fn.split(v, " -- ")[1]
    end
    return completions
end

---Tries to find root_dir pattern for a buffer autocmd. Fallback to <pattern> if
---root_dir is not found
local function get_root_dir_pattern()
    local pattern = "<buffer>"
    local active_clients = vim.lsp.get_active_clients()
    if #active_clients > 0 and active_clients[1].config and active_clients[1].config.root_dir then
        local root_dir = active_clients[1].config.root_dir
        if root_dir ~= vim.env.HOME then
            pattern = string.format("%s/*", root_dir)
        end
    end
    return pattern
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

    local pattern = get_root_dir_pattern()
    autocmd("BufWritePost", {
        group = augroup("RunOnSave", { clear = true }),
        pattern = pattern,
        callback = function()
            vim.schedule(function()
                if opts.args:sub(1, 1) == "!" then
                    M.term({
                        direction = "split",
                        focus = false,
                        cmd = string.sub(opts.args, 2),
                    })
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
            -- cd to dir which contains current buffer
            vim.cmd.lcd(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
            local completions = M.get_zsh_completion(string.sub(command, 2))

            if arg_lead:sub(1, 1) == "!" then
                for k in ipairs(completions) do
                    completions[k] = string.format("!%s", completions[k])
                end
            end
            return completions
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
    local file = vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(file, ":p:h")
    local output = vim.fn.fnamemodify(file, ":t:r")
    vim.cmd.write({ mods = { emsg_silent = true } })
    vim.api.nvim_echo({ { "Executing file" } }, false, {})
    if ft == "vim" or ft == "lua" then
        vim.cmd.source("%")
    elseif ft == "http" then
        -- Not really save and exec, but think it fits nicely in here for mapping
        require("rest-nvim").run()
    else
        vim.cmd.lcd(dir)
        local command = runner[ft]
        if not command then
            return vim.notify(
                string.format("No config found for %s", ft),
                vim.log.levels.INFO,
                { title = "Save and exec" }
            )
        end
        if type(command) == "function" then
            command = command()
        end

        command = command:gsub("$file", file)
        command = command:gsub("$output", output)
        command = command:gsub("$dir", dir)
        M.term({ direction = "split", focus = false, cmd = command })
    end
end

---------- HIDE CURSOR ----------

-- https://github.com/tamago324/lir.nvim/blob/master/lua/lir/smart_cursor/init.lua

local guicursor_saved = vim.opt.guicursor

local function hide_cursor()
    vim.opt.guicursor = vim.opt.guicursor + "a:CursorTransparent/lCursor"
end

function M.setup_hidden_cursor()
    hide_cursor()
    vim.opt_local.cursorline = true
    vim.opt_local.winhighlight = "CursorLine:CursorLineHiddenCursor"
    local group = augroup("HiddenCursor", {})
    autocmd({ "BufEnter", "WinEnter", "CmdwinLeave", "CmdlineLeave" }, {
        group = group,
        pattern = "<buffer>",
        callback = function()
            hide_cursor()
            vim.opt_local.cursorline = true
            vim.opt_local.winhighlight = "CursorLine:CursorLineHiddenCursor"
        end,
        desc = "Hide cursor",
    })
    autocmd({ "BufLeave", "WinLeave", "CmdwinEnter", "CmdlineEnter" }, {
        group = group,
        pattern = "<buffer>",
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
