---------- LSP CONFIG ----------

local M = {}
local settings = require("config.lspconfig.settings")

---------- MAPPINGS ----------

local function mappings()
    local function keymap(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = true
        opts.desc = string.format("Lsp: %s", opts.desc)
        vim.keymap.set(mode, l, r, opts)
    end

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
end

---------- SIGNS ----------

local function signs()
    local sign_define = vim.fn.sign_define
    sign_define("DiagnosticSignError", { text = "✘", texthl = "DiagnosticSignError" })
    sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
    sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
    -- sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
end

function M.make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_lsp.default_capabilities()
    end
    return {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            require("config.lspconfig.handlers").handlers()
            mappings()
            signs()
            if client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, bufnr)
            end

            -- Turn off semantic tokens
            client.server_capabilities.semanticTokensProvider = nil
        end,
    }
end

local servers = {}

local mason_ok, mason = pcall(require, "mason")
local ok, lsp_installer = pcall(require, "mason-lspconfig")
if ok and mason_ok then
    mason.setup()
    lsp_installer.setup()
    servers = lsp_installer.get_installed_servers()
end

-- Automatic setup for language servers
for _, server in pairs(servers) do
    local config = vim.tbl_deep_extend("error", M.make_config(), settings[server] or {})
    require("lspconfig")[server].setup(config)
end

require("lspconfig.ui.windows").default_options.border = CUSTOM_BORDER

return M
