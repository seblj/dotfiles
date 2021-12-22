local inoremap = vim.keymap.inoremap
local imap = vim.keymap.imap
local ok, lspkind = pcall(require, 'lspkind')
if not ok then
    return
end
local cmp = require('cmp')

-- stylua: ignore
inoremap({ '<C-space>', function() require('cmp').complete() end })

local term = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer', options = {
            keyword_pattern = [[\k\+]],
        } },
        { name = 'path' },
    },

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = {
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    },

    preselect = cmp.PreselectMode.None,

    -- Rounded borders on popup
    documentation = {
        border = 'rounded',
    },

    -- Make entry look like (icon, type, source) in completion menu
    formatting = {
        format = function(entry, item)
            item.kind = lspkind.presets.default[item.kind] .. ' ' .. item.kind
            item.menu = ({
                nvim_lsp = '[LSP]',
                buffer = '[Buffer]',
                luasnip = '[Luasnip]',
            })[entry.source.name]

            -- Append '...' if the entry is wider than max length
            local maxlength = 90
            local length = #item.abbr
            item.abbr = string.sub(item.abbr, 1, maxlength)
            if length > maxlength then
                item.abbr = item.abbr .. '...'
            end
            return item
        end,
    },
})

cmp.setup.cmdline('/', {
    completion = {
        autocomplete = false,
    },
    sources = {
        { name = 'buffer' },
    },
})

cmp.setup.cmdline('?', {
    completion = {
        autocomplete = false,
    },
    sources = {
        { name = 'buffer' },
    },
})

-- cmp.setup.cmdline(':', {
--     completion = {
--         autocomplete = false,
--     },
--     sources = cmp.config.sources({
--         { name = 'path' },
--     }, {
--         { name = 'cmdline' },
--     }),
-- })

vim.opt.completeopt = { 'menuone', 'noselect' }

local ls = require('luasnip')

_G.tab_complete = function()
    if require('cmp').visible() then
        return term('<C-n>')
    elseif ls.expand_or_jumpable() then
        return term('<Plug>luasnip-expand-or-jump')
    else
        return term('<Tab>')
    end
end

_G.s_tab_complete = function()
    if cmp.visible() then
        return term('<C-p>')
    elseif ls.jumpable(-1) then
        return term('<Plug>luasnip-jump-prev')
    else
        return term('<S-Tab>')
    end
end

imap({ '<Tab>', 'v:lua.tab_complete()', expr = true })
imap({ '<S-Tab>', 'v:lua.s_tab_complete()', expr = true })
