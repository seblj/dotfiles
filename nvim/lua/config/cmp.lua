---------- CMP ----------

local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer", option = {
            keyword_pattern = [[\k\+]],
        } },
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

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
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
        -- documentation = cmp.config.window.bordered(),
        -- completion = cmp.config.window.bordered(),
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
            },
            maxwidth = 90,
            ellipsis_char = "...",
        }),
    },
})
