---------- HANDLERS ----------

local M = {}

M.handlers = function()
    vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = '●' },
        signs = true,
        update_in_insert = false,
    })
    vim.lsp.buf.definition = require('telescope.builtin').lsp_definitions
    vim.lsp.buf.references = require('telescope.builtin').lsp_references

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
    })
    vim.lsp.handlers['window/showMessageRequest'] = function(_, result, _)
        return result
    end
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
        silent = true,
        focusable = false, -- Sometimes gets set to true if not set explicitly to false for some reason
    })
end

return M
