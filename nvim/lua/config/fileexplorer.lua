return {
    {
        "nvim-tree/nvim-tree.lua",
        opts = {
            actions = {
                open_file = {
                    resize_window = false,
                },
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, nowait = true }
                end

                vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
                vim.keymap.set("n", "Y", api.fs.copy.filename, opts("Copy Name"))
                vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
                vim.keymap.set("n", "dd", api.fs.remove, opts("Delete"))
                vim.keymap.set("n", "r", api.fs.rename_full, opts("Rename: Full Path"))
                vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
                vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
                vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
                vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
                vim.keymap.set("n", "_", api.tree.change_root_to_node, opts("CD"))
                vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
                vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
                vim.keymap.set("n", "gh", api.node.show_info_popup, opts("Info"))
                vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
                vim.keymap.set("n", "<C-r>", api.tree.reload, opts("Refresh"))
                vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
                vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
                vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
                vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
                vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
                vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
                vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))

                -- vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
                -- vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
            end,
        },
        keys = { { "<leader>nt", ":NvimTreeToggle<CR>" } },
    },
    {
        "stevearc/oil.nvim",
        init = function()
            vim.keymap.set("n", "-", "<cmd>Oil<CR>")
        end,
        opts = {
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = false,
                ["<C-h>"] = false,
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            view_options = { show_hidden = true },
            preview = { border = CUSTOM_BORDER },
        },
    },
}
