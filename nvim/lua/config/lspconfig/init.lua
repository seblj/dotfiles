---------- LSP CONFIG ----------

local function keymap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    opts.desc = string.format("Lsp: %s", opts.desc)
    vim.keymap.set(mode, l, r, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function(args)
        require("config.lspconfig.handlers").handlers()

        ---------- MAPPINGS ----------

        keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
        keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definitions" })
        keymap("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
        keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostic" })
        keymap("n", "<leader>dw", ":Telescope diagnostics<CR>", { desc = "Diagnostics in telescope" })
    end,
})

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
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
        local capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

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
        { "folke/neodev.nvim", config = true },
        { "b0o/schemastore.nvim" },
        { "williamboman/mason.nvim", config = true, cmd = "Mason" },
        { "williamboman/mason-lspconfig.nvim", config = true, cmd = { "LspInstall", "LspUninstall" } },
        { "Hoffs/omnisharp-extended-lsp.nvim" },
        { "seblj/nvim-lsp-extras", opts = { global = { border = CUSTOM_BORDER } }, dev = true },
    },
}
