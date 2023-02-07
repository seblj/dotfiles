local M = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local format_languages = {
    "eslint",
    "omnisharp",
}

function M.setup(client)
    if vim.tbl_contains(format_languages, client.name) then
        local group = augroup("AutoFormat", { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, pattern = "<buffer>" })
        autocmd("BufWritePre", {
            group = group,
            pattern = "<buffer>",
            callback = function()
                if not vim.b.disable_formatting then
                    if client.name == "eslint" then
                        vim.cmd.EslintFixAll()
                    else
                        vim.lsp.buf.format()
                    end
                end
            end,
            desc = "Formatting",
        })
    end
end

return M
