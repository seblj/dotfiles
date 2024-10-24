---------- LSP CONFIG ----------

local function keymap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    opts.desc = string.format("Lsp: %s", opts.desc)
    vim.keymap.set(mode, l, r, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function()
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = CUSTOM_BORDER })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = CUSTOM_BORDER })

        ---------- MAPPINGS ----------

        keymap("n", "grr", function()
            vim.lsp.buf.references(nil, {
                on_list = require("config.telescope").helpers.on_list({ prompt_title = "LSP References" }),
            })
        end)

        keymap("n", "gd", function()
            vim.lsp.buf.definition({
                on_list = require("config.telescope").helpers.on_list({ prompt_title = "LSP Definitions" }),
            })
        end)

        keymap("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
        keymap("n", "<leader>dw", ":Telescope diagnostics<CR>", { desc = "Diagnostics in telescope" })
        keymap("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = "Toggle inlay hints" })
    end,
})

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    float = { border = CUSTOM_BORDER, source = "if_many" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignHint",
        },
    },
})

return {
    "neovim/nvim-lspconfig",
    config = function()
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            ok and cmp_nvim_lsp.default_capabilities() or {}
        )

        require("mason-lspconfig").setup_handlers({
            function(server)
                local config = vim.tbl_deep_extend("error", {
                    capabilities = capabilities,
                }, require("config.lspconfig.settings")[server] or {})
                require("lspconfig")[server].setup(config)
            end,
        })

        require("lspconfig.ui.windows").default_options.border = CUSTOM_BORDER
    end,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
        },
        { "Bilal2453/luvit-meta", lazy = true },
        { "b0o/schemastore.nvim" },
        { "williamboman/mason.nvim", config = true, cmd = "Mason" },
        { "williamboman/mason-lspconfig.nvim", config = true, cmd = { "LspInstall", "LspUninstall" } },
        { "seblj/nvim-lsp-extras", opts = { global = { border = CUSTOM_BORDER } }, dev = true },
        { "onsails/lspkind.nvim" },
    },
}
