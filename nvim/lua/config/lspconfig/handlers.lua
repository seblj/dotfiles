---------- HANDLERS ----------

local M = {}

local override = function(handler, override_config)
    return function(opts, bufnr, line_nr, client_id)
        return handler(vim.tbl_deep_extend('force', opts or {}, override_config), bufnr, line_nr, client_id)
    end
end

M.handlers = function()
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = { spacing = 4, prefix = '●' },
        signs = true,
        update_in_insert = false,
    })

    vim.lsp.handlers['textDocument/codeAction'] = require('config.lspconfig.codeaction').handler
    vim.lsp.buf.rename = require('config.lspconfig.rename').rename
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
    })
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
        silent = true,
        focusable = false, -- Sometimes gets set to true if not set explicitly to false for some reason
    })
    vim.lsp.diagnostic.show_line_diagnostics = override(vim.lsp.diagnostic.show_line_diagnostics, {
        border = 'rounded',
    })
end

return M