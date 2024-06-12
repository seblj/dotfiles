# Alias

setopt auto_cd

alias ls="ls -G"
alias cp="cp -i"
alias mv="mv -i"

alias -g ..='..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias cht="~/dotfiles/scripts/cht.sh"
alias ssh_kitty="kitty +kitten ssh"
alias icat="kitty +kitten icat --align=left"
alias kitty_debug_font="kitty --debug-font-fallback"

function fmt() {
    nvim -u ~/.config/nvim/init.lua -i NONE -Es +":Format $*"
}

alias localip="ipconfig getifaddr en0"

# alias cat to bat if bat is installed
installed bat && alias cat="bat"
