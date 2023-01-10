local M = {}
local util = require('vim.lsp.util')

local function make_position_param(mouse, bufnr, offset_encoding)
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    if not clients then
        return
    end
    local row = mouse.line - 1
    local col = mouse.column

    offset_encoding = offset_encoding or util._get_offset_encoding(bufnr)
    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, true)[1]
    if not line or #line < col then
        return nil
    end

    col = util._str_utfindex_enc(line, col, offset_encoding)

    return { line = row, character = col }
end

local make_params = function(mouse, bufnr, offset_encoding)
    offset_encoding = offset_encoding or util._get_offset_encoding(bufnr)
    local position = make_position_param(mouse, bufnr, offset_encoding)
    if not position then
        return nil
    end
    return {
        textDocument = util.make_text_document_params(bufnr),
        position = position,
    }
end

local function hover_handler(_, result, ctx, config)
    config = {
        border = CUSTOM_BORDER,
        silent = true,
        focusable = false,
        relative = 'mouse',
        focus_id = ctx.method,
    }
    if not (result and result.contents) then
        if config.silent ~= true then
            vim.notify('No information available')
        end
        return
    end
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents, {})
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
        vim.notify('No information available')
        return
    end
    return util.open_floating_preview(markdown_lines, 'markdown', config)
end

M.setup = function()
    local hover_timer = nil
    vim.o.mousemoveevent = true

    vim.keymap.set({ '', 'i' }, '<MouseMove>', function()
        if hover_timer then
            hover_timer:close()
        end
        hover_timer = vim.defer_fn(function()
            hover_timer = nil
            local mouse = vim.fn.getmousepos()
            local bufnr = vim.api.nvim_win_get_buf(mouse.winid)
            local params = make_params(mouse, bufnr)
            if not params then
                return
            end
            vim.lsp.buf_request(bufnr, 'textDocument/hover', params, hover_handler)
        end, 500)
        return '<MouseMove>'
    end, { expr = true })
end

return M
