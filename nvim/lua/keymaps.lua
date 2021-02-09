---------- MAPPINGS ----------

local cmd, fn, g, exec = vim.cmd, vim.fn, vim.g, vim.api.nvim_exec
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
    for c in mode:gmatch"." do
        vim.api.nvim_set_keymap(c, lhs, rhs, options)
    end
end

-- Leader is space and localleader is \
g.mapleader = ' '
g.maplocalleader = "\\"

map('n', '<leader>m', ':MaximizerToggle!<CR>')                                  -- Maximize split

---------- GENERAL MAPPINGS ----------

map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})        -- Tab for next completion
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})      -- Shift-tab for previous completion
map('v', '<leader>p', '_dP')                                                    -- Not override clipboard
map('n', '<leader>=', '<C-w>=')                                                 -- Resize windows
map('n', '<leader>i', '<gg=G')                                                  -- Indent file
map('n', '<leader>s', ':%s//gI<Left><Left><Left>')                              -- Search and replace
map('v', '<leader>s', ':s//gI<Left><Left><Left>')                               -- Search and replace
map('n', '<leader>f', 'za')                                                     -- Fold
map('n', '<leader>l', ':nohl<CR>')                                              -- Remove highlight after search
map('n', '<Tab>', 'gt')                                                         -- Next tab
map('n', '<S-TAB>', 'gT')                                                       -- Previous tab
map('v', '<', '<gv')                                                            -- Keep visual on indent
map('v', '>', '>gv')                                                            -- Keep visual on indent
map('n', '<C-l>', '<C-w>l')                                                     -- Navigate to right split
map('n', '<C-h>', '<C-w>h')                                                     -- Navigate to left split
map('n', '<C-j>', '<C-w>j')                                                     -- Navigate to bottom split
map('n', '<C-k>', '<C-w>k')                                                     -- Navigate to top split
map('n', '<S-Right>', ':vertical resize -1<CR>')                                -- Resize split
map('n', '<S-Left>', ':vertical resize +1<CR>')                                 -- Resize split
map('n', '<S-Up>', ':res +1<CR>')                                               -- Resize split
map('n', '<S-Down>', ':res -1<CR>')                                             -- Resize split

map('n', '√', ':m.+1<CR>==')                                                    -- Move line with Alt-j
map('v', '√', ":m '>+1<CR>gv=gv")                                               -- Move line with Alt-j
map('i', '√', '<Esc>:m .+1<CR>==gi')                                            -- Move line with Alt-j

map('n', 'ª', ':m.-2<CR>==')                                                    -- Move line with Alt-k
map('v', 'ª', ":m '<-2<CR>gv=gv")                                               -- Move line with Alt-k
map('i' ,'ª', '<Esc>:m .-2<CR>==gi')                                            -- Move line with Alt-k

map('nv', 'J', '10j')                                                           -- 10 lines down with J
map('nv', 'K', '10k')                                                           -- 10 lines up with K
map('nvo', 'H', '^')                                                            -- Beginning of line
map('nvo', 'L', '$')                                                            -- End of line

cmd('cnoreabbrev w!! w suda://%')                                               -- Write with sudo
cmd('cnoreabbrev Q q')                                                          -- Quit with Q
cmd('cnoreabbrev W w')                                                          -- Write with W
cmd('cnoreabbrev WQ wq')                                                        -- Write and quit with WQ
cmd('cnoreabbrev Wq wq')                                                        -- Write and quit with Wq
cmd('cnoreabbrev Wqa wqa')                                                      -- Write and quit all with Wqa
cmd('cnoreabbrev WQa wqa')                                                      -- Write and quit all with WQa
cmd('cnoreabbrev WQA wqa')                                                      -- Write and quit all with WQA
cmd('cnoreabbrev Wa wa')                                                        -- Write all with Wa
cmd('cnoreabbrev WA wa')                                                        -- Write all with WA
cmd('cnoreabbrev Qa qa')                                                        -- Quit all with Qa
cmd('cnoreabbrev QA qa')                                                        -- Quit all with QA

---------- FUNCTIONS ----------

-- Function for using arrow keys as cnext and cprev only in quickfix window
exec(
[[
function! QuickFixFunc(key)
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        if a:key == "down"
            normal j
        else
            normal k
        endif
    else
        if a:key == "down"
            :silent! cnext
        else
            :silent! cprev
        endif
    endif
endfunction
]],
false
)

map('n', '<Down>', ':call QuickFixFunc("down")<CR>')                            -- Use down as cnext
map('n', '<Up>', ':call QuickFixFunc("up")<CR>')                                -- Use up as cprev

-- Function to execute macro over a visual range
exec(
[[
function! ExecuteMacroOverVisualRange()
echo "@".getcmdline()
execute ":'<,'>normal @".nr2char(getchar())
endfunction
]],
false
)

map('x', '@', ':<C-u>call ExecuteMacroOverVisualRange()<CR>')                   -- Macro over visual range
