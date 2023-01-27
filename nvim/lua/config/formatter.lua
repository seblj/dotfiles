local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function prettierd()
    return {
        exe = "prettierd",
        args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    }
end

local function path_pop(path)
    local new_path, _ = string.gsub(path, "/[^/]+$", "")
    return new_path == "" and "/" or new_path
end

local function get_os_command_output(cmd, cwd)
    local result = {}
    local job = vim.fn.jobstart(cmd, {
        cwd = cwd,
        stdout_buffered = true,
        on_stdout = function(_, output, _)
            result = output
        end,
    })
    vim.fn.jobwait({ job })

    return result
end

local function _reverse_find_file(file, dir)
    local files = get_os_command_output({ "ls", "-a1" }, dir)
    for _, x in pairs(files) do
        if x == file then
            return dir .. "/" .. file
        end
    end

    return dir == "/" and nil or _reverse_find_file(file, path_pop(dir))
end

local function reverse_find_file(file)
    return _reverse_find_file(file, path_pop(vim.api.nvim_buf_get_name(0)))
end

require("formatter").setup({
    filetype = {
        lua = function()
            return {
                exe = "stylua",
                args = { "--search-parent-directories", "--stdin-filepath", vim.api.nvim_buf_get_name(0), "-" },
            }
        end,
        go = function()
            return {
                exe = "goimports",
            }
        end,
        sql = function()
            local config = reverse_find_file(".sql-formatter.json")
            return {
                exe = "sql-formatter",
                -- args = { "-l", "postgresql" },
                args = config == nil and {} or { "--config", config },
            }
        end,
        rust = function()
            return {
                exe = "rustfmt",
                args = { "--edition", "2021" },
            }
        end,
        javascript = prettierd,
        typescript = prettierd,
        javascriptreact = prettierd,
        typescriptreact = prettierd,
        vue = prettierd,
        css = prettierd,
        scss = prettierd,
        html = prettierd,
        yaml = prettierd,
        markdown = prettierd,
        graphql = prettierd,
    },
})

local group = augroup("Formatter", {})
autocmd("BufWritePre", {
    pattern = { "*.lua", "*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.md", "*.css", "*.scss", "*.rs", "*.sql" },
    group = group,
    callback = function()
        if vim.b.do_formatting ~= false then
            vim.cmd.Format()
        end
    end,
    desc = "Formatting",
})
