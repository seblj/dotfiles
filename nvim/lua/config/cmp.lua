if vim.g.use_builtin_completion then
    require("seblyng.completion")
    return {}
end

if true then
    return {
        "saghen/blink.cmp",
        -- use a release tag to download pre-built binaries
        version = "*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = "default",
                ["<CR>"] = { "accept", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            },

            completion = {
                list = { selection = { preselect = false } },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = {
                        border = CUSTOM_BORDER,
                    },
                },
                menu = {
                    border = CUSTOM_BORDER,
                },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                cmdline = {},
            },
        },
        opts_extend = { "sources.default" },
    }
end

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        { "onsails/lspkind.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        {
            "xzbdmw/colorful-menu.nvim",
            opts = {
                ls = {
                    gopls = { align_type_to_right = false },
                    clangd = { align_type_to_right = false },
                    ["rust-analyzer"] = { align_type_to_right = false },
                },
            },
        },
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
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual",
                },
            },

            formatting = {
                fields = { "kind", "abbr" },
                format = (function()
                    local enable_colors = true

                    if enable_colors then
                        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bold = true })
                        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { bold = true })
                        ---@diagnostic disable-next-line: missing-fields
                        require("colorful-menu").setup({ max_width = 90, ls = { fallback = false } })
                    end
                    return function(entry, vim_item)
                        if enable_colors then
                            local highlights_info = require("colorful-menu").cmp_highlights(entry)

                            if highlights_info then
                                vim_item.abbr_hl_group = highlights_info.highlights
                                vim_item.abbr = highlights_info.text
                            end
                        end
                        return require("lspkind").cmp_format({ mode = "symbol" })(entry, vim_item)
                    end
                end)(),
            },
        }
    end,
}
