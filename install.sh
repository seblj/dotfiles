#!/bin/bash

# Sets varibale to dotfiles location
DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

# This sets variables needed for installation
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

# Installs homebrew and symlinks .macos if OS is macOS. Needs to be sourced before doing $UPDATE
source $DOTFILES/install/mac.sh

# Runs 'brew update' or 'sudo apt-get update' based on OS
$UPDATE

# Installation
source $DOTFILES/install/common.sh
source $DOTFILES/install/neovim.sh
source $DOTFILES/install/zsh.sh

# Hopefully fix insecure directories if there are any
/bin/zsh -i -c compaudit | xargs chmod g-w,o-w >/dev/null 2>&1

printf "\n${BLUE}Finishing up! ${NC}\n\n"
