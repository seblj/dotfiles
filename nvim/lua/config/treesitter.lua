---------- TREESITTER CONFIG ----------

vim.treesitter.language.register("bash", "zsh")

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "*" },
--     callback = function(args)
--         print("trying to attach to: ", args.buf, vim.bo.ft)
--         if not pcall(vim.treesitter.start, args.buf) then
--             return
--         end
--         vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--     end,
-- })

-- require("nvim-treesitter").setup({
--     auto_install = true,
-- })
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",

                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>sa"] = "@parameter.inner",
                ["<leader>sf"] = "@function.outer",
            },
            swap_previous = {
                ["<leader>sA"] = "@parameter.inner",
                ["<leader>sF"] = "@function.outer",
            },
        },
    },
})
