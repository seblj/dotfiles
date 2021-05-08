local utils = require('seblj.utils')
local map = utils.map
local cmd = vim.cmd

--------- ADAPTERS ----------

local dap = require('dap')
dap.adapters.cpp = {
    type = 'executable',
    attach = {
        pidProperty = "pid",
        pidSelect = "ask"
    },
    command = 'lldb-vscode',
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}
dap.adapters.python = {
    type = 'executable';
    command = '/Users/sebastianlyngjohansen/.virtualenvs/debugpy/bin/python3';
    args = { '-m', 'debugpy.adapter' };
}

---------- MAPPINGS ----------

map('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>')
map('n', '<leader>d<leader>', '<cmd>lua require("dap").continue()<CR>')
map('n', '<leader>dl', '<cmd>lua require("dap").step_into()<CR>')
map('n', '<leader>dj', '<cmd>lua require("dap").step_over()<CR>')

dap.repl.commands = vim.tbl_extend('force', dap.repl.commands, {
    continue = {'.continue', '.c', 'c'},
    next_ = {'.next', '.n', 'n'},
    into = {'.into, .i, i'},
})


---------- UI ----------

vim.fn.sign_define('DapBreakpoint', {text='', texthl='Error', linehl='', numhl=''})

require("dapui").setup({
    icons = {
        expanded = "",
        collapsed = "",
        circular = "↺"
    },
    sidebar = {
        elements = {
            "scopes",
            "watches"
        },
        width = 40,
        position = "left"
    },
    tray = {
        elements = {
            'repl'
        },
        height = 10,
        position = "bottom"
    },
})


---------- COMMANDS ----------

cmd([[command! -complete=file -nargs=* DebugC lua require "config.dap".start_c_debugger({<f-args>}, "gdb")]])
cmd([[command! -complete=file -nargs=* DebugRust lua require "config.dap".start_c_debugger({<f-args>}, "gdb", "rust-gdb")]])

---------- CONFIG ----------

dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        pythonPath = function()
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python3') == 1 then
                return cwd .. '/venv/bin/python3'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python3') == 1 then
                return cwd .. '/.venv/bin/python3'
            else
                return '/usr/local/bin/python3'
            end
        end;
    },
}



local M = {}
local last_gdb_config

M.start_c_debugger = function(args, mi_mode, mi_debugger_path)
    if args and #args > 0 then
        last_gdb_config = {
            type = "cpp",
            name = args[1],
            request = "launch",
            program = table.remove(args, 1),
            args = args,
            cwd = vim.fn.getcwd(),
            env = {"VAR1=value1", "VAR2=value"},
            externalConsole = true,
            MIMode = mi_mode or "gdb",
            MIDebuggerPath = mi_debugger_path
        }
    end

    if not last_gdb_config then
        print('No binary to debug set! Use ":DebugC <binary> <args>" or ":DebugRust <binary> <args>"')
        return
    end

    dap.run(last_gdb_config)
end

return M
