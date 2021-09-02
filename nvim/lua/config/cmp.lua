local inoremap = vim.keymap.inoremap
local lspkind = require('lspkind')
local cmp = require('cmp')

-- stylua: ignore
inoremap({ '<C-space>', function() require('cmp').complete() end })

cmp.setup({
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer', opts = {
            keyword_pattern = [[\k\+]],
        } },
        { name = 'path' },
    },

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    preselect = cmp.PreselectMode.None,

    -- Rounded borders on popup
    documentation = {
        border = 'rounded',
    },

    -- Autoimport on enter
    mapping = {
        ['<cr>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
        }),
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

vim.opt.completeopt = { 'menuone', 'noselect' }
