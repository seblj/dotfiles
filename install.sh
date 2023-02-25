#!/bin/bash

# Sets varibale to dotfiles location
OS=$(uname -s)

# This sets variables needed for installation
source $HOME/dotfiles/install/utils.sh

if [ "$EUID" -ne 0 ]; then
    printf "\n${RED}You need to run this script with sudo! ${NC}"
    exit
fi

# Installs homebrew and symlinks .macos if OS is macOS. Needs to be sourced before doing $UPDATE
if [[ $OS == "Darwin" ]]; then
    source $HOME/dotfiles/install/mac.sh
fi

# Runs 'brew update' or 'apt-get update' based on OS
$UPDATE >/dev/null

# Installation
if [[ $1 == "" ]]; then
    source $HOME/dotfiles/install/common.sh
    source $HOME/dotfiles/install/packages.sh
    source $HOME/dotfiles/install/neovim.sh
    source $HOME/dotfiles/install/zsh.sh
elif [[ $1 == 'nvim' ]]; then
    source $HOME/dotfiles/install/neovim.sh
elif [[ $1 == 'zsh' ]]; then
    source $HOME/dotfiles/install/zsh.sh
fi

chsh -s $(which zsh)

# Hopefully fix insecure directories if there are any
/bin/zsh -i -c compaudit | xargs chmod g-w,o-w >/dev/null 2>&1
