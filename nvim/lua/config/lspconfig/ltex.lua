-- Big thanks to this gist which helped me a lot
-- https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8

local M = {}

M.file = {
    dictionary = vim.fn.stdpath('config') .. '/spell/en.utf-8.add',
    disabledRules = vim.fn.stdpath('config') .. '/spell/disable.txt',
    hiddenFalsePositives = vim.fn.stdpath('config') .. '/spell/false.txt',
}

local file_exists = function(file)
    local f = io.open(file, 'rb')
    if f then
        f:close()
    end
    return f ~= nil
end

M.lines_from = function(file)
    if not file_exists(file) then
        return {}
    end
    local lines = {}
    for line in io.lines(file) do
        table.insert(lines, line)
    end
    return lines
end

local get_client_by_name = function(name)
    local buf_clients = vim.lsp.buf_get_clients()
    for _, client in ipairs(buf_clients) do
        if client.name == name then
            return client
        end
    end
    return nil
end

local update_config = function(lang, configtype)
    local client = get_client_by_name('ltex')
    if client then
        if client.config.settings.ltex[configtype] then
            client.config.settings.ltex[configtype] = {
                [lang] = M.lines_from(M.file[configtype]),
            }
            return client.notify('workspace/didChangeConfiguration', client.config.settings)
        else
            return vim.notify('Error when reading dictionary config, check it')
        end
    else
        return nil
    end
end

local add_to_file = function(configtype, lang, file, value)
    local dict = M.lines_from(file)
    for _, v in ipairs(dict) do
        if v == value then
            return nil
        end
    end
    file = io.open(file, 'a+')
    if file then
        file:write(value .. '\n')
        file:close()
    else
        return vim.notify(string.format('Failed insert %s', value))
    end
    return update_config(lang, configtype)
end

local do_command = function(arg, configtype)
    for lang, words in pairs(arg) do
        for _, word in ipairs(words) do
            add_to_file(configtype, lang, M.file[configtype], word)
        end
    end
end

local orig_execute_command = vim.lsp.buf.execute_command
vim.lsp.buf.execute_command = function(command)
    local arg = command.arguments[1]
    if command.command == '_ltex.addToDictionary' then
        do_command(arg.words, 'dictionary')
    elseif command.command == '_ltex.disableRules' then
        do_command(arg.ruleIds, 'disabledRules')
    elseif command.command == '_ltex.hideFalsePositives' then
        do_command(arg.falsePositives, 'hiddenFalsePositives')
    else
        orig_execute_command(command)
    end
end

M.on_attach = function(client)
    require('config.lspconfig').make_config().on_attach(client)
    vim.keymap.set('n', 'zuw', function()
        vim.cmd('normal! zuw')
        update_config('en-US', 'dictionary')
    end, {
        buffer = true,
        desc = 'Remove word from spellfile and update ltex',
    })
    vim.keymap.set('n', 'zg', function()
        vim.cmd('normal! zg')
        update_config('en-US', 'dictionary')
    end, {
        buffer = true,
        desc = 'Add word to spellfile and update ltex',
    })
end

return M
