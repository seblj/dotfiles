---------- VIMSPECTOR CONFIG ----------

local g = vim.g
local function map(mode, lhs, rhs, opts)
    local options = {silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    for c in mode:gmatch"." do
        vim.api.nvim_set_keymap(c, lhs, rhs, options)
    end
end

g.vimspector_base_dir='/Users/sebastianlyngjohansen/.config/vimspector-config'

-- Repeat remaps for vimspector
map('n', '<Plug>VimspectorStepOutRepeat', ':call vimspector#StepOut()<CR> :call repeat#set("\\<Plug>VimspectorStepOutRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorStepOverRepeat', ':call vimspector#StepOver()<CR> :call repeat#set("\\<Plug>VimspectorStepOverRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorStepIntoRepeat', ':call vimspector#StepInto()<CR> :call repeat#set("\\<Plug>VimspectorStepIntoRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorContinueRepeat', ':call vimspector#Continue()<CR> :call repeat$set("\\<Plug>VimspectorContinueRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorRunToCursorRepeat', ':call vimspector#RunToCursor()<CR> :call repeat#set("\\<Plug>VimspectorRunToCursorRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorToggleBreakpointRepeat', ':call vimspector#ToggleBreakpoint()<CR> :call repeat#set("\\<Plug>VimspectorToggleBreakpointRepeat", v:count)<CR>')

-- " Remap the comands created for repeat
map('n', '<leader>vd', ':call vimspector#Launch()<CR>')
map('n', '<leader>ve', ':call vimspector#Reset()<CR>')

map('n', '<Leader>vk', '<Plug>VimspectorStepOutRepeat')
map('n', '<Leader>vj', '<Plug>VimspectorStepOverRepeat')
map('n', '<Leader>vl', '<Plug>VimspectorStepIntoRepeat')
map('n', '<leader>vr', '<Plug>VimspectorRestart')
map('n', '<leader>v<space>', ':call vimspector#Continue()<CR>')

map('n', '<leader>vc', '<Plug>VimspectorRunToCursorRepeat')
map('n', '<leader>vb', '<Plug>VimspectorToggleBreakpointRepeat')
map('n', '<leader>vcb', '<Plug>VimspectorToggleConditionalBreakpoint')
map('n', '<leader>vw', '"iyiw:VimspectorWatch <C-r>"<CR>')
