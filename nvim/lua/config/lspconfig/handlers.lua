---------- HANDLERS ----------

local M = {}

M.handlers = function()
    vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = '●' },
        float = { border = CUSTOM_BORDER, source = 'if_many' },
        signs = true,
        update_in_insert = false,
    })
    vim.lsp.buf.definition = require('telescope.builtin').lsp_definitions
    vim.lsp.buf.references = require('telescope.builtin').lsp_references

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = CUSTOM_BORDER,
    })
    vim.lsp.handlers['window/showMessageRequest'] = function(_, result, _)
        return result
    end
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = CUSTOM_BORDER,
    })
end

return M
