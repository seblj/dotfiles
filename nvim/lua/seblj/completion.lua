local function feedkeys(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", true)
end

vim.keymap.set("i", "<C-space>", vim.lsp.completion.trigger)

vim.keymap.set("i", "<CR>", function()
    if vim.fn.complete_info()["selected"] ~= -1 then
        return feedkeys("<C-y>")
    else
        local ok, npairs = pcall(require, "nvim-autopairs")
        if ok then
            return npairs.autopairs_cr()
        else
            if vim.fn.pumvisible() then
                return feedkeys("<C-e><CR>")
            else
                return feedkeys("<CR>")
            end
        end
    end
end, { expr = true, replace_keycodes = false, desc = "Accept completion" })

-- I want autocompletion, so do a hack to add all these chars to the servers triggerchars
-- stylua: ignore
local triggerchars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F',
    'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
    'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_'
}

local current_win_data = nil

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id) --[[@as vim.lsp.Client]]
        if not client.supports_method("textDocument/completion") then
            return
        end

        -- Some weird things happening when `volar` is started as well as `ts_ls`.
        -- It adds an extra `.` sometimes, but I cannot figure out why
        if client.name == "volar" then
            return
        end

        local ok, kinds = pcall(require, "lspkind")
        local lsp_triggerchars = vim.tbl_get(client, "server_capabilities", "completionProvider", "triggerCharacters")
        if lsp_triggerchars then
            vim.list_extend(client.server_capabilities.completionProvider.triggerCharacters, triggerchars)
        end
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
            -- TODO: Sort of annoying with the "flickering" when it does multiple requests
            autotrigger = true,
            convert = function(item)
                local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
                local kind = ok and string.format("%s %s", kinds.presets.default[kind_name], kind_name) or kind_name
                return { kind = kind, kind_hlgroup = string.format("CmpItemKind%s", kind_name) }
            end,
        })

        vim.api.nvim_create_autocmd("CompleteChanged", {
            buffer = args.buf,
            callback = function()
                vim.schedule(function()
                    -- Prevent against error for invalid lnum since we allow for scrolling
                    if current_win_data and vim.api.nvim_win_is_valid(current_win_data.winid) then
                        vim.api.nvim_win_set_cursor(current_win_data.winid, { 1, 0 })
                    end

                    local info = vim.fn.complete_info({ "selected", "mode" })
                    -- Strip the final `/` to automatically continue completion
                    if info.selected ~= -1 and info.mode == "files" then
                        local line = vim.api.nvim_get_current_line():gsub("/$", "")
                        vim.api.nvim_set_current_line(line)
                    end

                    local complete = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
                    if complete == nil then
                        return
                    end

                    local resolved = client.request_sync("completionItem/resolve", complete, 500, args.buf) or {}
                    local docs = vim.tbl_get(resolved, "result", "documentation", "value")
                    if docs == nil then
                        return
                    end

                    local contents = vim.split(docs, "\n", { trimempty = true })
                    local scratch = vim.api.nvim_create_buf(false, true)
                    local stylized_docs = table.concat(vim.lsp.util.stylize_markdown(scratch, contents, {}), "\n")

                    local win_data = vim.api.nvim__complete_set(info["selected"], { info = stylized_docs })
                    if not win_data.winid or not vim.api.nvim_win_is_valid(win_data.winid) then
                        return
                    end
                    current_win_data = win_data

                    vim.bo[win_data.bufnr].modifiable = true
                    vim.wo[win_data.winid].conceallevel = 2

                    vim.lsp.util.stylize_markdown(win_data.bufnr, contents, {})
                    vim.api.nvim_win_set_config(win_data.winid, { border = CUSTOM_BORDER })

                    vim.bo[win_data.bufnr].modifiable = false
                    -- Simple scrolling in the preview window
                    local scroll = function(key, dir)
                        vim.keymap.set("i", key, function()
                            if vim.api.nvim_buf_is_valid(win_data.bufnr) then
                                vim.api.nvim_buf_call(win_data.bufnr, function()
                                    vim.cmd(string.format("normal! %s zt", dir))
                                end)
                            else
                                feedkeys(key)
                            end
                        end, { buffer = args.buf })
                    end

                    scroll("<C-d>", "5j")
                    scroll("<C-u>", "5k")
                end)
            end,
        })
    end,
})

local function should_complete_file()
    -- It stops completing when "accepting" since it includes trailing slash for dirs
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line_text = vim.api.nvim_get_current_line()
    if line_text:sub(col, col) == "/" and vim.v.char:match("%S") then
        return true
    end

    -- Trigger chars for normal cases
    if not vim.list_contains({ "/" }, vim.v.char) then
        return
    end

    -- Some inspiration from nvim-cmp for when to do path completion
    local prefix = line_text:sub(1, col) .. vim.v.char
    return not (
        prefix:match("%a+://?$") -- Ignore URL scheme
        or prefix:match("</$") -- Ignore HTML closing tags
        or prefix:match("[%d%)]%s*/$") -- Ignore math calculation
        or (prefix:match("^[%s/]*$") and vim.bo.commentstring:match("/[%*/]")) -- Ignore / comment
    )
end

-- Completion for path (and omni if no language server is attached to buffer)
vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function(args)
        local invalid_buftype = vim.list_contains({ "terminal", "prompt", "help" }, vim.bo[args.buf].buftype)
        if vim.fn.pumvisible() == 1 or invalid_buftype then
            return
        end

        local buf_has_client = #vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/completion" }) > 0

        if should_complete_file() then
            feedkeys("<C-X><C-F>")
        elseif not vim.v.char:match("%s") and not buf_has_client then
            feedkeys("<C-X><C-N>")
        end
    end,
})
