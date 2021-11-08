#!/bin/bash

# Sets varibale to dotfiles location
DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

# This sets variables needed for installation
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

if [[ $OS == "Linux" ]]; then
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible
else
    pip install ansible
fi

# Hopefully fix insecure directories if there are any
/bin/zsh -i -c compaudit | xargs chmod g-w,o-w >/dev/null 2>&1
