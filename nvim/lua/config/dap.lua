---------- DEBUGGER CONFIG ----------

local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command

--------- ADAPTERS ----------

local dap = require('dap')
dap.adapters.cpp = {
    type = 'executable',
    attach = {
        pidProperty = 'pid',
        pidSelect = 'ask',
    },
    command = 'lldb-vscode',
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = 'YES',
    },
    name = 'lldb',
}
dap.adapters.python = {
    type = 'executable',
    command = '/Users/sebastianlyngjohansen/.virtualenvs/debugpy/bin/python3',
    args = { '-m', 'debugpy.adapter' },
}

dap.adapters.go = function(callback, _)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
        stdio = { nil, stdout },
        args = { 'dap', '-l', '127.0.0.1:' .. port },
        detached = true,
    }
    handle, pid_or_err = vim.loop.spawn('dlv', opts, function(code)
        stdout:close()
        handle:close()
        if code ~= 0 then
            print('dlv exited with code', code)
        end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function()
                require('dap.repl').append(chunk)
            end)
        end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
        callback({ type = 'server', host = '127.0.0.1', port = port })
    end, 100)
end

---------- MAPPINGS ----------

-- Use vim.repeat to enable repeat with .
keymap('n', '<Plug>DapBreakpointRepeat', function()
    require('dap').toggle_breakpoint()
    vim.cmd('call repeat#set("<Plug>DapBreakpointRepeat")')
end, {
    desc = 'Repeat: support for Dap: breakpoint',
})
keymap('n', '<Plug>DapContinueRepeat', function()
    require('dap').continue()
    vim.cmd('call repeat#set("<Plug>DapContinueRepeat")')
end, {
    desc = 'Repeat: support for Dap: continue',
})
keymap('n', '<Plug>DapStepIntoRepeat', function()
    require('dap').step_into()
    vim.cmd('call repeat#set("<Plug>DapStepIntoRepeat")')
end, {
    desc = 'Repeat: support for Dap: step into',
})
keymap('n', '<Plug>DapStepOverRepeat', function()
    require('dap').step_over()
    vim.cmd('call repeat#set("<Plug>DapStepOverRepeat")')
end, {
    desc = 'Repeat: support for Dap: step over',
})

keymap('n', '<leader>db', '<Plug>DapBreakpointRepeat', { desc = 'Dap: Add breakpoint' })
keymap('n', '<leader>d<leader>', '<Plug>DapContinueRepeat', { desc = 'Dap: Continue debugging' })
keymap('n', '<leader>dl', '<Plug>DapStepIntoRepeat', { desc = 'Dap: Step into' })
keymap('n', '<leader>dj', '<Plug>DapStepOverRepeat', { desc = 'Dap: Step over' })

dap.repl.commands = vim.tbl_extend('force', dap.repl.commands, {
    continue = { '.continue', '.c', 'c' },
    next_ = { '.next', '.n', 'n' },
    into = { '.into, .i, i' },
})

---------- UI ----------

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Error', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '→', texthl = 'Error', linehl = 'DiffAdd', numhl = '' })

local dapui = require('dapui')
dapui.setup({
    icons = {
        expanded = '',
        collapsed = '',
        circular = '↺',
    },
    layouts = {
        {
            elements = {
                { id = 'scopes', size = 0.25 },
                { id = 'watches', size = 0.25 },
            },
            size = 40,
            position = 'left',
        },
        {

            elements = {
                'repl',
            },
            size = 10,
            position = 'bottom',
        },
    },
})

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

---------- CONFIG ----------

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
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
        end,
    },
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = 'go',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
    },
    {
        type = 'go',
        name = 'Debug test',
        request = 'launch',
        mode = 'test',
        program = '${file}',
    },
}

local last_gdb_config
local start_c_debugger = function(args, mi_mode, mi_debugger_path)
    if args and #args > 0 then
        last_gdb_config = {
            type = 'cpp',
            name = args[1],
            request = 'launch',
            program = table.remove(args, 1),
            args = args,
            cwd = vim.fn.getcwd(),
            env = { 'VAR1=value1', 'VAR2=value' },
            externalConsole = true,
            MIMode = mi_mode or 'gdb',
            MIDebuggerPath = mi_debugger_path,
        }
    end

    if not last_gdb_config then
        print('No binary to debug set! Use ":DebugC <binary> <args>" or ":DebugRust <binary> <args>"')
        return
    end

    dap.run(last_gdb_config)
end

---------- COMMANDS ----------

command('DebugC', function(opts)
    start_c_debugger({ opts.args }, 'gdb')
end, {
    nargs = '*',
    complete = 'file',
})

command('DebugRust', function(opts)
    start_c_debugger({ opts.args }, 'gdb', 'rust-gdb')
end, {
    nargs = '*',
    complete = 'file',
})
