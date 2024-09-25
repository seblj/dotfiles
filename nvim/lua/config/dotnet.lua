return {
    "seblj/roslyn.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        filewatching = false,
        broad_search = true,
        choose_sln = function(sln)
            return vim.iter(sln):find(function(item)
                if string.match(item, "SmartDok.Luna.Api.sln") then
                    return item
                end
            end)
        end,
    },
    dev = true,
    init = function()
        local all_files = nil

        -- TODO: Make it better, and also have devicons showing
        vim.keymap.set("n", "<leader>ds", function()
            local conf = require("telescope.config").values
            local finders = require("telescope.finders")

            if all_files then
                require("telescope.pickers")
                    .new({}, {
                        prompt_title = "Find solution files",
                        finder = finders.new_table({ results = all_files }),
                        previewer = conf.grep_previewer({}),
                        sorter = conf.file_sorter({}),
                    })
                    :find()
                return
            end

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

            local git_root = vim.fs.root(0, ".git")
            local git_res = vim.system({ "git", "ls-files" }, { cwd = git_root }):wait()
            local git_files = vim.split(git_res.stdout, "\n")

            -- TODO: This is quite slow... Is there any better way to find all solution files?
            local files = vim.iter(git_files)
                :map(function(file)
                    local full_file = vim.fs.joinpath(git_root, file)

                    for _, project in ipairs(csproj_files) do
                        local dir = string.format("%s/", vim.fs.dirname(project))
                        if string.find(full_file, dir, 0, true) then
                            return vim.fn.fnamemodify(full_file, ":~:.")
                        end
                    end
                end)
                :totable()

            all_files = files

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Find solution files",
                    finder = finders.new_table({ results = all_files }),
                    previewer = conf.grep_previewer({}),
                    sorter = conf.file_sorter({}),
                })
                :find()
        end)
    end,
}
