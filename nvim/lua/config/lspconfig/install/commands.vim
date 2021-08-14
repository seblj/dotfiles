" Create custom commands with completion to install language servers

function! Lspinstall_available_servers() abort
  return luaeval('require("config.lspconfig.install").available_servers()')
endfunction

function! Complete_install(arg, line, pos) abort
  return join(Lspinstall_available_servers(), "\n")
endfunction

command! -nargs=1 -complete=custom,Complete_install LspInstall | lua require("config.lspconfig.install").install_server("<args>")
