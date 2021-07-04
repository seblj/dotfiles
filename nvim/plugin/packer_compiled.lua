-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/sebastianlyngjohansen/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/sebastianlyngjohansen/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/sebastianlyngjohansen/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/sebastianlyngjohansen/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/sebastianlyngjohansen/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "require('config.luasnip')" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/LuaSnip"
  },
  ["conflict-marker.vim"] = {
    config = { "\27LJ\2\n¥\1\0\0\2\0\a\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0)\1\0\0=\1\6\0K\0\1\0$conflict_marker_enable_mappings\17^>>>>>>> .*$\24conflict_marker_end\17^<<<<<<< .*$\26conflict_marker_begin\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/conflict-marker.vim"
  },
  ["galaxyline.nvim"] = {
    config = { "require('config.galaxyline')" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "require('config.gitsigns')" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim"
  },
  ["lir.nvim"] = {
    config = { "require('config.fileexplorer')" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/lir.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "require('config.autopairs')" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-colorizer.lua"] = {
    config = { "require('colorizer').setup()" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    after_files = { "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "require('config.compe')" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-compe"
  },
  ["nvim-dap"] = {
    after = { "nvim-dap-ui" },
    config = { "require('config.dap')" },
    keys = { { "", "<leader>db" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-dap-ui"
  },
  ["nvim-echo-diagnostics"] = {
    config = { "require('echo-diagnostics').setup{}" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-echo-diagnostics"
  },
  ["nvim-lspconfig"] = {
    config = { "require('config.lspconfig')" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tabline"] = {
    config = { "require('tabline').setup{}" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-tabline"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeOpen" },
    config = { "require('config.luatree')" },
    keys = { { "", "<leader>tt" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "nvim-ts-context-commentstring", "nvim-ts-autotag", "nvim-treesitter-textobjects" },
    loaded = true,
    only_config = true
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects"
  },
  ["nvim-ts-autotag"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["nvim-xamarin"] = {
    config = { "require('xamarin').setup{}" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/nvim-xamarin"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["rest.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/rest.nvim"
  },
  ["suda.vim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/suda.vim"
  },
  tabular = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/tabular"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "require('config.telescope')" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-maximizer"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/vim-maximizer"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-startify"] = {
    config = { "require('config.startify')" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    config = { "\27LJ\2\nq\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\5#startuptime_split_edit_key_seq\6i\"startuptime_more_info_key_seq\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/vim-startuptime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-test"] = {
    config = { "require('config.test')" },
    loaded = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/start/vim-test"
  },
  ["vim-ultest"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/vim-ultest"
  },
  vimtex = {
    config = { "require('config.vimtex')" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/vimtex"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: lir.nvim
time([[Config for lir.nvim]], true)
require('config.fileexplorer')
time([[Config for lir.nvim]], false)
-- Config for: nvim-echo-diagnostics
time([[Config for nvim-echo-diagnostics]], true)
require('echo-diagnostics').setup{}
time([[Config for nvim-echo-diagnostics]], false)
-- Config for: vim-startify
time([[Config for vim-startify]], true)
require('config.startify')
time([[Config for vim-startify]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
require('config.lspconfig')
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-xamarin
time([[Config for nvim-xamarin]], true)
require('xamarin').setup{}
time([[Config for nvim-xamarin]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
require('config.galaxyline')
time([[Config for galaxyline.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require('config.treesitter')
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
require('colorizer').setup()
time([[Config for nvim-colorizer.lua]], false)
-- Config for: vim-test
time([[Config for vim-test]], true)
require('config.test')
time([[Config for vim-test]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require('config.telescope')
time([[Config for telescope.nvim]], false)
-- Config for: nvim-tabline
time([[Config for nvim-tabline]], true)
require('tabline').setup{}
time([[Config for nvim-tabline]], false)
-- Conditional loads
time("Condition for { 'vim-ultest' }", true)
if
try_loadstring("\27LJ\2\n\15\0\0\1\0\0\0\2+\0\1\0L\0\2\0\0", "condition", '{ "vim-ultest" }')
then
time("Condition for { 'vim-ultest' }", false)
time([[packadd for vim-ultest]], true)
		vim.cmd [[packadd vim-ultest]]
	time([[packadd for vim-ultest]], false)
else
time("Condition for { 'vim-ultest' }", false)
end
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-treesitter-textobjects ]]
vim.cmd [[ packadd nvim-ts-context-commentstring ]]
vim.cmd [[ packadd nvim-ts-autotag ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file NvimTreeOpen lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <leader>tt <cmd>lua require("packer.load")({'nvim-tree.lua'}, { keys = "<lt>leader>tt", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>db <cmd>lua require("packer.load")({'nvim-dap'}, { keys = "<lt>leader>db", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType bib ++once lua require("packer.load")({'vimtex'}, { ft = "bib" }, _G.packer_plugins)]]
vim.cmd [[au FileType http ++once lua require("packer.load")({'rest.nvim'}, { ft = "http" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'vimtex'}, { ft = "tex" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'LuaSnip', 'nvim-autopairs'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufWritePre * ++once lua require("packer.load")({'gitsigns.nvim'}, { event = "BufWritePre *" }, _G.packer_plugins)]]
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'conflict-marker.vim', 'gitsigns.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], true)
vim.cmd [[source /Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]]
time([[Sourcing ftdetect script at: /Users/sebastianlyngjohansen/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: ".v:exception | echom "Please check your config for correctness" | echohl None')
end
