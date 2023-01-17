---------- UTILS ----------

local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

-- Reloads config for nvim so I don't need to reopen buffer in some cases
function M.reload_config()
    vim.cmd.source("~/dotfiles/nvim/init.lua")
    for pack, _ in pairs(package.loaded) do
        if pack:match("^config") or pack:match("^seblj") then
            package.loaded[pack] = nil
            require(pack)
        end
    end
    vim.api.nvim_echo({ { "Reloaded config" } }, false, {}) -- Don't add to message history
end

-- direction should be one of
-- 'split'
-- 'vsplit'
-- 'tabnew'
function M.run_term(opts, ...)
    local terminal = vim.fn.filter(vim.fn.getwininfo(), "v:val.terminal")[1]
    local current_win = vim.api.nvim_get_current_win()
    if not terminal or opts.new then
        local height = vim.api.nvim_win_get_height(0)
        vim.cmd[opts.direction]()
        if opts.direction == "split" then
            vim.api.nvim_win_set_height(0, math.floor(height / 3))
        end
        vim.cmd.term()
        vim.cmd("$")
        terminal = vim.fn.filter(vim.fn.getwininfo(), "v:val.terminal")[1]
        if not opts.focus then
            vim.api.nvim_set_current_win(current_win)
        end
    end
    vim.api.nvim_chan_send(vim.b[terminal.bufnr].terminal_job_id, string.format(opts.cmd .. "\n", ...))
    keymap("n", "q", "<cmd>q<CR>", { buffer = true })
    if opts.stopinsert then
        vim.cmd.stopinsert()
    end
end

function M.get_zsh_completion(command)
    local ok, Job = pcall(require, "plenary.job")
    if not ok then
        return {}
    end
    local res
    Job:new({
        command = "capture",
        args = { command },
        on_exit = function(j)
            res = j:result()
        end,
    }):sync()

    for k, v in ipairs(res) do
        res[k] = vim.fn.split(v, " -- ")[1]
    end
    return res
end

vim.api.nvim_create_user_command("RunOnSave", function(opts)
    local pattern = "<buffer>"
    -- Try to find a root_dir to use that as pattern since I probably often want
    -- to run the command on all the files in the project. If I get annoyed by
    -- this, then just make a `RunOnSaveBuffer` or something to always use
    -- buffer no matter what
    local active_clients = vim.lsp.get_active_clients()
    if #active_clients > 0 and active_clients[1].config and active_clients[1].config.root_dir then
        local root_dir = active_clients[1].config.root_dir
        if root_dir ~= vim.env.HOME then
            pattern = string.format("%s/*", root_dir)
        end
    end
    autocmd("BufWritePost", {
        group = augroup("RunOnSave", { clear = true }),
        pattern = pattern,
        callback = function()
            vim.schedule(function()
                if opts.args:sub(1, 1) == "!" then
                    M.run_term({
                        direction = "split",
                        focus = false,
                        stopinsert = true,
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
            local file = vim.api.nvim_buf_get_name(0)
            local dir = vim.fn.fnamemodify(file, ":p:h")
            vim.cmd.lcd(dir)
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

vim.api.nvim_create_user_command("RunOnSaveClear", function()
    vim.api.nvim_clear_autocmds({ group = "RunOnSave" })
end, { bang = true })

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
            vim.api.nvim_echo({ { string.format("No config found for %s", ft) } }, false, {})
            return
        end
        if type(command) == "function" then
            command = command()
        end

        command = command:gsub("$file", file)
        command = command:gsub("$output", output)
        command = command:gsub("$dir", dir)
        M.run_term({ direction = "split", focus = false, stopinsert = true, cmd = command })
    end
end

function M.read_file(path)
    local fd = assert(vim.loop.fs_open(path, "r", 438))
    local stat = assert(vim.loop.fs_fstat(fd))
    return vim.loop.fs_read(fd, stat.size, 0)
end

function M.override_queries(lang, query_name)
    local queries_folder = vim.fs.normalize("~/dotfiles/nvim/lua/config/treesitter/queries")
    if require("nvim-treesitter.parsers").has_parser(lang) then
        vim.treesitter.query.set_query(
            lang,
            query_name,
            M.read_file(queries_folder .. string.format("/%s/%s.scm", lang, query_name))
        )
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
            vim.opt.guicursor = vim.opt.guicursor + "a:Cursor/lCursor"
            vim.opt.guicursor = guicursor_saved
            vim.opt_local.cursorline = false
        end,
        desc = "Show cursor",
    })
end

----------------------------------------

return M
