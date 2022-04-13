require('dirbuf').setup({
    sort_order = 'directories_first',
})

-- Disable dirbufs global mapping of '-' if I haven't set any mapping for '-' myself
if vim.fn.mapcheck('-', '-') == '' then
    vim.keymap.set('n', '-', '<nop>')
end
