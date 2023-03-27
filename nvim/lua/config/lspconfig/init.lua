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
        local bufnr = args.buf
        require("config.lspconfig.handlers").handlers()

        if client.server_capabilities.documentSymbolProvider and pcall(require, "nvim-navic") then
            require("nvim-navic").attach(client, bufnr)
        end

        -- Turn off semantic tokens
        client.server_capabilities.semanticTokensProvider = nil

        ---------- MAPPINGS ----------

        keymap("n", "gr", vim.lsp.buf.references, { desc = "References" })
        keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definitions" })
        keymap({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })
        keymap("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
        keymap("n", "gR", vim.lsp.buf.rename, { desc = "Rename" })
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
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

require("mason").setup()
require("mason-lspconfig").setup()
local servers = require("mason-lspconfig").get_installed_servers()

-- Automatic setup for language servers
for _, server in pairs(servers) do
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local config = vim.tbl_deep_extend("error", {
        capabilities = ok and cmp_nvim_lsp.default_capabilities() or {},
    }, require("config.lspconfig.settings")[server] or {})
    require("lspconfig")[server].setup(config)
end

require("lspconfig.ui.windows").default_options.border = CUSTOM_BORDER

return M
