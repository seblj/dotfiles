# Exports

export DOTFILES="$HOME/dotfiles"
export OS=$(uname -s)
export XDG_CONFIG_HOME="$HOME/.config"
export PATH=$HOME/.local/share/nvim/mason/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

if [[ $OS == "Darwin" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
fi

export _Z_DATA="$HOME/.config/z/.z."
export FZF_DEFAULT_OPTS='--height 40%'

typeset -U path
path+=(
    /usr/local/opt/llvm/bin
    $HOME/.cargo/bin
    $HOME/.local/ltex/bin
    $HOME/.local/bin
    /opt/homebrew/opt/dotnet@6/bin
    /Applications/WezTerm.app/Contents/MacOS
    $HOME/.local/flutter/bin
)

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export PATH="$PATH:$HOME/.dotnet/tools"

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export MANPAGER='nvim +Man!'

export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP="$HOME/.cache/zsh/.zcompdump-${HOST/.*/}-${ZSH_VERSION}"
