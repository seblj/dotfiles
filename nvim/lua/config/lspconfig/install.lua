local keymap = vim.keymap.set

local servers = {
    pyright = 'npm install -g pyright',
    rust_analyzer = 'brew install rust-analyzer',
    cssls = 'npm i -g vscode-langservers-extracted',
    eslint = 'npm i -g vscode-langservers-extracted',
    vimls = 'npm install -g vim-language-server',
    texlab = 'cargo install --git https://github.com/latex-lsp/texlab.git --locked',
    html = 'npm i -g vscode-langservers-extracted',
    bashls = 'npm i -g bash-language-server',
    vuels = 'npm install -g vls',
    volar = 'npm install -g @volar/vue-language-server',
    jsonls = 'npm i -g vscode-langservers-extracted',
    graphql = 'npm install -g graphql-language-service-cli',
    tsserver = 'npm install -g typescript typescript-language-server',
    sumneko_lua = 'brew install lua-language-server',
    dockerls = 'npm install -g dockerfile-language-server-nodejs',
}

local install_server = function(ls)
    vim.cmd('new')
    local command = servers[ls]
    vim.fn.termopen('set -e\n' .. command)

    keymap('n', 'q', '<cmd>q<CR>', { buffer = true })
    vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('LspInstall', function(opts)
    install_server(opts.args)
end, {
    complete = function(search)
        return vim.tbl_filter(function(server)
            return server:match(search)
        end, vim.tbl_keys(servers))
    end,
    nargs = 1,
})
