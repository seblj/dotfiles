return {
    "seblj/roslyn.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        filewatching = false,
        broad_search = true,
        ignore_sln = function(sln)
            return string.match(sln, "SmartDok.sln") ~= nil
        end,
    },
    dev = true,
    init = function()
        vim.keymap.set("n", "<leader>ds", function()
            if not vim.g.roslyn_nvim_selected_solution then
                return vim.notify("No solution file found")
            end

            local projects = require("roslyn.sln.api").projects(vim.g.roslyn_nvim_selected_solution)
            local files = vim.iter(projects)
                :map(function(it)
                    return vim.fs.dirname(it)
                end)
                :totable()

            local root = vim.fs.root(0, ".git") or vim.fs.dirname(vim.g.roslyn_nvim_selected_solution)

            require("telescope.pickers")
                .new({}, {
                    cwd = root,
                    prompt_title = "Find solution files",
                    finder = require("telescope.finders").new_oneshot_job(
                        vim.list_extend({ "fd", "--type", "f", "." }, files),
                        { entry_maker = require("telescope.make_entry").gen_from_file({ cwd = root }) }
                    ),
                    sorter = require("telescope.config").values.file_sorter({}),
                    previewer = require("telescope.config").values.grep_previewer({}),
                })
                :find()
        end)
    end,
}
