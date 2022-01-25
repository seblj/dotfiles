require('dirbuf').setup({
    sort_order = function(l, r)
        if l.ftype ~= r.ftype then
            return l.ftype < r.ftype
        else
            return l.fname:lower() < r.fname:lower()
        end
    end,
})

-- Disable dirbufs global mapping of '-' if I haven't set any mapping for '-' myself
if vim.fn.mapcheck('-', '-') == '' then
    vim.keymap.set('n', '-', '<nop>')
end
