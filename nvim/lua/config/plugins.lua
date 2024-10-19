return {
    { "seblj/nvim-tabline", config = true, event = "TabNew", dev = true },

    -- TODO: Either make it work with injections or look into only using this if it is a "leptos" file
    -- { "rayliwell/tree-sitter-rstml", config = true, dev = true },
    { "seblj/nvim-ts-autotag", config = true, event = { "BufReadPost", "BufNewFile" }, dev = true },

    {
        "github/copilot.vim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.copilot_enabled = 0
        end,
    },

    -- Git
    { "akinsho/git-conflict.nvim", config = true, event = { "BufReadPre", "BufWritePre" } },

    -- Packageinfo
    { "saecki/crates.nvim", config = true, event = "BufReadPre Cargo.toml" },
    { "vuki656/package-info.nvim", config = true, event = "BufReadPre package.json" },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- UI
    { "brenoprata10/nvim-highlight-colors", config = true, event = { "BufReadPre", "BufNewFile" } },
    {
        "Bekaboo/dropbar.nvim",
        opts = {
            general = {
                enable = function(buf, win)
                    return not vim.api.nvim_win_get_config(win).zindex
                        and vim.bo[buf].buftype == ""
                        and vim.api.nvim_buf_get_name(buf) ~= ""
                        and not vim.wo[win].diff
                end,
            },
        },
        cond = not (vim.uv.os_uname().sysname == "Windows_NT"),
    },
    {
        "j-hui/fidget.nvim",
        opts = { notification = { override_vim_notify = true }, integration = { ["nvim-tree"] = { enable = false } } },
    },

    -- Functionality
    { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", ft = "markdown" },
    { "chomosuke/term-edit.nvim", opts = { prompt_end = "➜" }, event = "TermOpen" },
    { "ahonn/resize.vim" },

    {
        "windwp/nvim-autopairs",
        opts = { map_cr = not vim.g.use_builtin_completion, ignored_next_char = "[%w%.%{%[%(%\"%']" },
        event = "InsertEnter",
    },
    { "lambdalisue/suda.vim", keys = { { "w!!", "SudaWrite", mode = "ca" } }, lazy = false },

    -- Tpope
    { "tpope/vim-repeat" },
    { "tpope/vim-abolish" },
    { "tpope/vim-unimpaired" },
    {
        "tpope/vim-surround",
        keys = {
            { "s", "<Plug>Ysurround", desc = "Surround with motion" },
            { "S", "<Plug>Yssurround", desc = "Surround entire line" },
            { "s", "<Plug>VSurround", mode = "x", desc = "Surround visual" },
        },
        lazy = false,
    },
    { "tpope/vim-scriptease" },
    { "tpope/vim-sleuth" },
}
