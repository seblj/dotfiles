local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local prettierd = function()
    return {
        exe = 'prettierd',
        args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
        stdin = true,
        cond = function()
            local active_clients = vim.lsp.get_active_clients()
            for _, client in ipairs(active_clients) do
                if client.name == 'eslint' then
                    return false
                end
            end
            return true
        end,
    }
end

require('formatter').setup({
    filetype = {
        lua = {
            function()
                return {
                    exe = 'stylua',
                    args = { '--search-parent-directories', '-' },
                    stdin = true,
                }
            end,
        },
        go = {
            function()
                return {
                    exe = 'goimports',
                    stdin = true,
                }
            end,
        },
        javascript = { prettierd },
        typescript = { prettierd },
        javascriptreact = { prettierd },
        typescriptreact = { prettierd },
        vue = { prettierd },
        css = { prettierd },
        scss = { prettierd },
        html = { prettierd },
        yaml = { prettierd },
        markdown = { prettierd },
        graphql = { prettierd },
    },
})

local group = augroup('Formatter', {})
autocmd('BufWritePre', {
    pattern = { '*.lua', '*.go', '*.js', '*.ts', '*.jsx', '*.tsx', '*.css', '*.vue', '*.md' },
    group = group,
    callback = function()
        if vim.b.do_formatting ~= false then
            vim.cmd('FormatWrite')
        end
    end,
})