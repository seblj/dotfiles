return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "onsails/lspkind.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
    },

    opts = function()
        local cmp = require("cmp")
        return {
            sources = {
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "buffer", option = { keyword_pattern = [[\k\+]] } },
                { name = "path" },
                { name = "crates" },
                { name = "vim-dadbod-completion" },
            },

            confirmation = {
                -- This seems annoying, so disable it for now for all language servers
                get_commit_characters = function(_)
                    return {}
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),

            preselect = cmp.PreselectMode.None,

            window = {
                documentation = {
                    border = CUSTOM_BORDER,
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
                },
                completion = {
                    border = CUSTOM_BORDER,
                    winhighlight = "FloatBorder:FloatBorder,CursorLine:Visual",
                },
            },

            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",
                    menu = {
                        nvim_lsp = "[LSP]",
                        buffer = "[Buffer]",
                        luasnip = "[Luasnip]",
                        path = "[Path]",
                        crates = "[Crates]",
                        ["vim-dadbod-completion"] = "[DB]",
                    },
                    maxwidth = 90,
                    ellipsis_char = "...",
                }),
            },
        }
    end,
}
