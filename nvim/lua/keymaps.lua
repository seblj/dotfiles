---------- MAPPINGS ----------

local utils = require('utils')
local cmd, g, map = vim.cmd, vim.g, utils.map

-- Leader is space and localleader is \
g.mapleader = ' '
g.maplocalleader = "\\"

---------- GENERAL MAPPINGS ----------

map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})        -- Tab for next completion
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})      -- Shift-tab for previous completion
map('n', '<Tab>', 'gt')                                                         -- Next tab
map('n', '<S-TAB>', 'gT')                                                       -- Previous tab
map('n', '<leader>r', ':lua require("utils").reload_config()<CR>')              -- Reload config
map('n', '<leader>=', '<C-w>=')                                                 -- Resize windows
map('n', '<leader>i', '<gg=G')                                                  -- Indent file
map('n', '<leader>s', ':%s//gI<Left><Left><Left>', {silent = false})            -- Search and replace
map('v', '<leader>s', ':s//gI<Left><Left><Left>', {silent = false})             -- Search and replace
map('n', '<leader>l', ':nohl<CR>')                                              -- Remove highlight after search
map('n', '<leader>d', '"_d')                                                    -- Delete without yank
map('v', '<leader>d', '"_d')                                                    -- Delete without yank
map('n', '<C-f>', 'za')                                                         -- Fold

map('n', '<C-h>', '<C-w>h')                                                     -- Navigate to left split
map('n', '<C-j>', '<C-w>j')                                                     -- Navigate to bottom split
map('n', '<C-k>', '<C-w>k')                                                     -- Navigate to top split
map('n', '<C-l>', '<C-w>l')                                                     -- Navigate to right split

map('t', '<C-h>', '<C-\\><C-N><C-w>h')                                          -- Navigate to left split
map('t', '<C-j>', '<C-\\><C-N><C-w>j')                                          -- Navigate to bottom split
map('t', '<C-k>', '<C-\\><C-N><C-w>k')                                          -- Navigate to top split
map('t', '<C-l>', '<C-\\><C-N><C-w>l')                                          -- Navigate to right split

map('n', '<S-Right>', ':vertical resize -1<CR>')                                -- Resize split
map('n', '<S-Left>', ':vertical resize +1<CR>')                                 -- Resize split
map('n', '<S-Up>', ':res +1<CR>')                                               -- Resize split
map('n', '<S-Down>', ':res -1<CR>')                                             -- Resize split
map('v', '<', '<gv')                                                            -- Keep visual on indent
map('v', '>', '>gv')                                                            -- Keep visual on indent

map('n', '√', ':m.+1<CR>==')                                                    -- Move line with Alt-j
map('v', '√', ":m '>+1<CR>gv=gv")                                               -- Move line with Alt-j
map('i', '√', '<Esc>:m .+1<CR>==gi')                                            -- Move line with Alt-j

map('n', 'ª', ':m.-2<CR>==')                                                    -- Move line with Alt-k
map('v', 'ª', ":m '<-2<CR>gv=gv")                                               -- Move line with Alt-k
map('i' ,'ª', '<Esc>:m .-2<CR>==gi')                                            -- Move line with Alt-k

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

map('x', '@', ':<C-u>:lua require("utils").visual_macro()<CR>')                 -- Macro over visual range
map('n', '<leader>z', ':lua require("utils").syn_stack()<CR>')                  -- Get syntax group
map('n', '<Down>', ':lua require("utils").quickfix("down")<CR>')                -- Move down in quickfixlist
map('n', '<Up>', ':lua require("utils").quickfix("up")<CR>')                    -- Move up in quickfixlist
map('n', '<leader><ESC>', ':cclose<CR> `A')                                     -- Close and go to mark

map('t', '<Esc><Esc>', '<C-\\><C-n>')                                           -- Exit term-mode

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
