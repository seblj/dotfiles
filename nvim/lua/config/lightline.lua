---------- LIGHTLINE CONFIG ----------

local g, exec = vim.g, vim.api.nvim_exec

exec(
[[
function! GitsignsBranch()
    return get(b:,'gitsigns_head','')
endfunction
]],
false
)

g.lightline = {
    colorscheme = 'custom',
    active = {
        left = { { 'mode', 'paste' }, { 'spell', 'gitbranch', 'readonly', 'filename', 'modified' }},
        right = { { 'lineinfo' }, { 'filetype' }}
    },
    component = {
        lineinfo = "%{line('.') . '/' . line('$')}",
    },
    -- component_function = {
    --     gitbranch = 'GitsignsBranch'},
    -- },
}

g.lightline.separator = {
	left = '',
    right = ''
}
g.lightline.subseparator = {
    left = '',
    right = '' 
}

