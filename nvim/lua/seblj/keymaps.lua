---------- MAPPINGS ----------

local utils = require('seblj.utils')
local cmd, g, map = vim.cmd, vim.g, utils.map

-- Leader is space and localleader is \
g.mapleader = ' '
g.maplocalleader = "\\"

---------- GENERAL MAPPINGS ----------

map('n', 'œ', '<Tab>')                                                          -- Alt-o for jumplist
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})        -- Tab for next completion
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})      -- Shift-tab for previous completion
map('n', '<Tab>', 'gt')                                                         -- Next tab
map('n', '<S-TAB>', 'gT')                                                       -- Previous tab
map('n', '<leader>r', ':lua require("seblj.utils").reload_config()<CR>')        -- Reload config
map('n', '<leader>=', '<C-w>=')                                                 -- Resize windows
map('n', '<leader>i', 'gg=G')                                                   -- Indent file
map('n', 'ß', ':%s//gI<Left><Left><Left>', {silent = false})                    -- Search and replace (Alt-s)
map('v', 'ß', ':s//gI<Left><Left><Left>', {silent = false})                     -- Search and replace (Alt-s)
map('n', '<CR>', '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', {expr = true})  -- Remove highlights with enter
map('n', '<C-f>', 'za')                                                         -- Fold
map('n', '<C-t>', ':tabedit<CR>')                                               -- Create new tab

map('n', '<C-h>', '<C-w>h')                                                     -- Navigate to left split
map('n', '<C-j>', '<C-w>j')                                                     -- Navigate to bottom split
map('n', '<C-k>', '<C-w>k')                                                     -- Navigate to top split
map('n', '<C-l>', '<C-w>l')                                                     -- Navigate to right split

map('t', '<C-h>', '<C-\\><C-N><C-w>h')                                          -- Navigate to left split
map('t', '<C-j>', '<C-\\><C-N><C-w>j')                                          -- Navigate to bottom split
map('t', '<C-k>', '<C-\\><C-N><C-w>k')                                          -- Navigate to top split
map('t', '<C-l>', '<C-\\><C-N><C-w>l')                                          -- Navigate to right split
map('t', '<Esc><Esc>', '<C-\\><C-n>')                                           -- Exit term-mode

map('n', '<S-Right>', ':lua require("seblj.utils").resize_right()<CR>')         -- Resize split right
map('n', '<S-Left>', ':lua require("seblj.utils").resize_left()<CR>')           -- Resize split left
map('n', '<S-Up>', ':lua require("seblj.utils").resize_up()<CR>')               -- Resize split up
map('n', '<S-Down>', ':lua require("seblj.utils").resize_down()<CR>')           -- Resize split down

map('v', '<', '<gv')                                                            -- Keep visual on indent
map('v', '>', '>gv')                                                            -- Keep visual on indent

map('n', '√', ':m.+1<CR>==')                                                    -- Move line with Alt-j
map('v', '√', ":m '>+1<CR>gv=gv")                                               -- Move line with Alt-j
map('i', '√', '<Esc>:m .+1<CR>==gi')                                            -- Move line with Alt-j

map('n', 'ª', ':m.-2<CR>==')                                                    -- Move line with Alt-k
map('v', 'ª', ":m '<-2<CR>gv=gv")                                               -- Move line with Alt-k
map('i' ,'ª', '<Esc>:m .-2<CR>==gi')                                            -- Move line with Alt-k

map('n', '<leader>j', 'J')                                                      -- Join lines

map('n', 'J', '10j')                                                            -- 10 lines down with J
map('v', 'J', '10j')                                                            -- 10 lines down with J
map('n', 'K', '10k')                                                            -- 10 lines up with K
map('v', 'K', '10k')                                                            -- 10 lines up with K

map('n', 'H', '^')                                                              -- Beginning of line
map('n', 'L', '$')                                                              -- End of line
map('v', 'H', '^')                                                              -- Beginning of line
map('v', 'L', '$')                                                              -- End of line
map('o', 'H', '^')                                                              -- Beginning of line
map('o', 'L', '$')                                                              -- End of line

map('n', '<leader>x', ':lua require("seblj.utils").save_and_exec()<CR>')        -- Save and execute vim or lua file
map('x', '@', ':<C-u>:lua require("seblj.utils").visual_macro()<CR>')           -- Macro over visual range
map('n', '<leader>z', ':lua require("seblj.utils").syn_stack()<CR>')            -- Get syntax group
map('n', '<Down>', ':lua require("seblj.utils").quickfix("down")<CR>')          -- Move down in quickfixlist
map('n', '<Up>', ':lua require("seblj.utils").quickfix("up")<CR>')              -- Move up in quickfixlist
map('n', '<leader><ESC><leader>', ':cclose<CR> `A')                             -- Close and go to mark
map('n', '<leader>@', ':lua require("seblj.utils").cd()<CR>')                   -- cd to directory of open buffer

cmd('cnoreabbrev w!! w suda://%')                                               -- Write with sudo
cmd('cnoreabbrev !! <C-r>:')                                                    -- Repeat last command
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

cmd('command! -nargs=* T split | term <args>')                                  -- Open term in split with T
cmd('command! -nargs=* VT vsplit | term <args>')                                -- Open term in vsplit with VT

