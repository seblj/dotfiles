# Alias

alias cp="cp -i"
alias mv="mv -i"

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

# Avoid nesting
if [ -n "$NVIM" ]; then
    alias nvim="nvr"
fi
