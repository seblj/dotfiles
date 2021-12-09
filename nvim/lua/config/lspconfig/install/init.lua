vim.cmd('source ~/dotfiles/nvim/lua/config/lspconfig/install/commands.vim')
local nnoremap = vim.keymap.nnoremap

local servers = {
    pyright = 'npm install -g pyright',
    rust_analyzer = 'brew install rust-analyzer',
    cssls = 'npm i -g vscode-langservers-extracted',
    vimls = 'npm install -g vim-language-server',
    texlab = 'cargo install --git https://github.com/latex-lsp/texlab.git --locked',
    html = 'npm i -g vscode-langservers-extracted',
    bashls = 'npm i -g bash-language-server',
    vuels = 'npm install -g vls',
    jsonls = 'npm i -g vscode-langservers-extracted',
    graphql = 'npm install -g graphql-language-service-cli',
    tsserver = 'npm install -g typescript typescript-language-server',
    sumneko_lua = 'brew install lua-language-server',
    dockerls = 'npm install -g dockerfile-language-server-nodejs',
}

local find_command = function(ls)
    for language, cmd in pairs(servers) do
        if ls == language then
            return cmd
        end
    end
end

local M = {}

M.available_servers = function()
    return vim.tbl_keys(servers)
end

M.install_server = function(ls)
    vim.cmd('new')
    local command = find_command(ls)
    vim.fn.termopen('set -e\n' .. command)

    nnoremap({ 'q', '<cmd>q<CR>', buffer = true })
    vim.cmd('startinsert')
end

return M
