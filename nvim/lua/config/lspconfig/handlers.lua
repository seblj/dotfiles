---------- HANDLERS ----------

local M = {}

function M.handlers()
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

    -- Jump directly to the first available definition every time
    -- unless the definitions different line number for some reason.
    -- sumneko_lua sometimes returns same line number but different
    -- column for defintion, so don't care which one we jump to
    -- Thanks to https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/handlers.lua
    vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx)
        if not result or vim.tbl_isempty(result) then
            return vim.notify("Lsp: Could not find definition")
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)

        if vim.tbl_islist(result) then
            local results = vim.lsp.util.locations_to_items(result, client.offset_encoding)
            local lnum, filename = results[1].lnum, results[1].filename
            for _, val in pairs(results) do
                if val.lnum ~= lnum or val.filename ~= filename then
                    return require("telescope.builtin").lsp_definitions()
                end
            end
            vim.lsp.util.jump_to_location(result[1], client.offset_encoding, false)
        else
            vim.lsp.util.jump_to_location(result, client.offset_encoding, false)
        end
    end
    vim.lsp.handlers["textDocument/references"] = function(_, _, _)
        require("telescope.builtin").lsp_references()
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = CUSTOM_BORDER,
    })
    vim.lsp.handlers["window/showMessageRequest"] = function(_, result, _)
        return result
    end
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = CUSTOM_BORDER,
    })
end

return M
