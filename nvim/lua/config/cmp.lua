local keymap = vim.keymap.set
local lspkind = require('lspkind')
local cmp = require('cmp')
local feedkeys = require('cmp.utils.feedkeys')

local term = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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
        ['<C-Space>'] = cmp.mapping({ i = cmp.mapping.complete() }),
        ['<Tab>'] = cmp.mapping({
            c = function(fallback)
                if #cmp.core:get_sources() > 0 and not cmp.get_config().experimental.native_menu then
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        cmp.complete()
                        vim.defer_fn(function()
                            if cmp.visible() then
                                feedkeys.call(term('<C-n>'), 'i')
                            end
                        end, 10)
                    end
                else
                    fallback()
                end
            end,
        }),
    },

    preselect = cmp.PreselectMode.None,

    -- Rounded borders on popup
    -- documentation = {
    --     border = 'rounded',
    --     scrollbar = '║',
    -- },

    -- This is for the PR with borders
    window = {
        documentation = {
            border = 'rounded',
            scrollbar = '║',
        },

        completion = {
            border = 'rounded',
            scrollbar = '║',
        },
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

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local ls = require('luasnip')

keymap('i', '<Tab>', function()
    if cmp.visible() then
        return term('<C-n>')
    else
        return term('<Tab>')
    end
end, {
    expr = true,
    remap = true,
    desc = 'Cmp: Next completion',
})

keymap('i', '<S-Tab>', function()
    if cmp.visible() then
        return term('<C-p>')
    else
        return term('<S-Tab>')
    end
end, {
    expr = true,
    remap = true,
    desc = 'Cmp: Previous completion',
})
