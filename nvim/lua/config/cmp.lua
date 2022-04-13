local lspkind = require('lspkind')
local cmp = require('cmp')
local types = require('cmp.types')

cmp.setup({
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer', option = {
            keyword_pattern = [[\k\+]],
        } },
        { name = 'path' },
        { name = 'crates' },
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
        ['<C-y>'] = cmp.mapping(
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            { 'i', 'c' }
        ),
        ['<C-n>'] = cmp.mapping(function()
            if not cmp.visible() then
                cmp.complete()
            else
                cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
            end
        end),
        ['<C-p>'] = cmp.mapping(function()
            if not cmp.visible() then
                cmp.complete()
            else
                cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
            end
        end),
    },

    preselect = cmp.PreselectMode.None,

    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
    },

    -- Make entry look like (icon, type, source) in completion menu
    formatting = {
        format = function(entry, item)
            item.kind = lspkind.presets.default[item.kind] .. ' ' .. item.kind
            item.menu = ({
                nvim_lsp = '[LSP]',
                buffer = '[Buffer]',
                luasnip = '[Luasnip]',
                path = '[Path]',
                crates = '[Crates]',
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

-- Looks really nice, but it misses some completion
-- items that I like from the builtin
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

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
