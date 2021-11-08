#!/bin/bash

# Sets varibale to dotfiles location
OS=$(uname -s)

if [[ $OS == "Linux" ]]; then
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
else
    pip install ansible
fi

ansible-playbook -K ansible/local.yml
sudo chsh -s $(which zsh)

# Hopefully fix insecure directories if there are any
/bin/zsh -i -c compaudit | xargs chmod g-w,o-w >/dev/null 2>&1
