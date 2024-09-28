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
            processId = dap_utils.pick_process,
        },

        {
            type = "coreclr",
            name = "Attach (Smart)",
            request = "attach",
            processId = function()
                if not vim.g.roslyn_nvim_selected_solution then
                    return vim.notify("No solution file found")
                end

                local solution_dir = vim.fs.dirname(vim.g.roslyn_nvim_selected_solution)

                local res = vim.system({ "dotnet", "sln", vim.g.roslyn_nvim_selected_solution, "list" }):wait()
                local csproj_files = vim.iter(vim.split(res.stdout, "\n"))
                    :map(function(it)
                        local fullpath = vim.fs.normalize(vim.fs.joinpath(solution_dir, it))
                        if fullpath ~= solution_dir and vim.uv.fs_stat(fullpath) then
                            return fullpath
                        else
                            return nil
                        end
                    end)
                    :totable()

                return dap_utils.pick_process({
                    filter = function(proc)
                        return vim.iter(csproj_files):find(function(file)
                            if vim.endswith(proc.name, vim.fn.fnamemodify(file, ":t:r")) then
                                return true
                            end
                        end)
                    end,
                })
            end,
        },
    }
end

return {
    setup = setup,
}
