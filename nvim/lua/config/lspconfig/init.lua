---------- LSP CONFIG ----------

local M = {}

local function keymap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    opts.desc = string.format("Lsp: %s", opts.desc)
    vim.keymap.set(mode, l, r, opts)
end

local function sign(name, text)
    vim.fn.sign_define(name, { text = text, texthl = name })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Turn off semantic tokens
        client.server_capabilities.semanticTokensProvider = nil

        require("config.lspconfig.handlers").handlers()

        ---------- MAPPINGS ----------

        keymap("n", "gr", vim.lsp.buf.references, { desc = "References" })
        keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definitions" })
        keymap({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })
        keymap("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
        keymap("n", "gR", vim.lsp.buf.rename, { desc = "Rename" })
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        keymap("n", "gp", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
        keymap("n", "gn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
        keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostic" })
        keymap("n", "<leader>dw", ":Telescope diagnostics<CR>", { desc = "Diagnostics in telescope" })

        ---------- SIGNS ----------

        sign("DiagnosticSignError", "✘")
        sign("DiagnosticSignWarn", "")
        sign("DiagnosticSignHint", "")
    end,
})

local servers = require("mason-lspconfig").get_installed_servers()

-- Automatic setup for language servers
for _, server in pairs(servers) do
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local config = vim.tbl_deep_extend("error", {
        capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities(),
    }, require("config.lspconfig.settings")[server] or {})
    require("lspconfig")[server].setup(config)
end

require("lspconfig.ui.windows").default_options.border = CUSTOM_BORDER

return M
