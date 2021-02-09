---------- VIMSPECTOR CONFIG ----------

local cmd, fn, g, exec = vim.cmd, vim.fn, vim.g, vim.api.nvim_exec
local function map(mode, lhs, rhs, opts)
    local options = {silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    for c in mode:gmatch"." do
        vim.api.nvim_set_keymap(c, lhs, rhs, options)
    end
end


-- Repeat remaps for vimspector
map('n', '<Plug>VimspectorStepOutRepeat', ':call vimspector#StepOut()<CR> :call repeat#set("\\<Plug>VimspectorStepOutRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorStepOverRepeat', ':call vimspector#StepOver()<CR> :call repeat#set("\\<Plug>VimspectorStepOverRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorStepIntoRepeat', ':call vimspector#StepInto()<CR> :call repeat#set("\\<Plug>VimspectorStepIntoRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorContinueRepeat', ':call vimspector#Continue()<CR> :call repeat$set("\\<Plug>VimspectorContinueRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorRunToCursorRepeat', ':call vimspector#RunToCursor()<CR> :call repeat#set("\\<Plug>VimspectorRunToCursorRepeat", v:count)<CR>')
map('n', '<Plug>VimspectorToggleBreakpointRepeat', ':call vimspector#ToggleBreakpoint()<CR> :call repeat#set("\\<Plug>VimspectorToggleBreakpointRepeat", v:count)<CR>')

-- " Remap the comands created for repeat
map('n', '<leader>dd', ':call vimspector#Launch()<CR>')
map('n', '<leader>de', ':call vimspector#Reset()<CR>')

map('n', '<Leader>dk', '<Plug>VimspectorStepOutRepeat')
map('n', '<Leader>dj', '<Plug>VimspectorStepOverRepeat')
map('n', '<Leader>dl', '<Plug>VimspectorStepIntoRepeat')
map('n', '<leader>d_', '<Plug>VimspectorRestart')
map('n', '<leader>d<space>', ':call vimspector#Continue()<CR>')

map('n', '<leader>drc', '<Plug>VimspectorRunToCursorRepeat')
map('n', '<leader>db', '<Plug>VimspectorToggleBreakpointRepeat')
map('n', '<leader>dcb', '<Plug>VimspectorToggleConditionalBreakpoint')
map('n', '<leader>dw', ':VimspectorWatch')
