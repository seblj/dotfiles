local function setup()
    local dap = require("dap")
    local dap_utils = require("dap.utils")

    dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "Launch",
            request = "launch",
            program = function()
                local project_path = vim.fs.root(0, function(name)
                    return name:match("%.csproj$") ~= nil
                end)

                if not project_path then
                    return vim.notify("Couldn't find the csproj path")
                end

                return dap_utils.pick_file({
                    filter = string.format("Debug/.*/%s", vim.fn.fnamemodify(project_path, ":t:r")),
                    path = string.format("%s/bin", project_path),
                })
            end,
        },

        {
            type = "coreclr",
            name = "Attach",
            request = "attach",
            processId = function()
                return dap_utils.pick_process({
                    filter = function(proc)
                        ---@diagnostic disable-next-line: return-type-mismatch
                        return proc.name:match(".*/Debug/.*") and not proc.name:find("vstest.console.dll")
                    end,
                })
            end,
        },
    }
end

return {
    setup = setup,
}
