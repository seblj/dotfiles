#!/bin/bash
# Installation of commong things

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

# Install necessary dependencies if not already installed
install_packages(){
    packages=(
        zsh
        curl
        gcc
        g++
        nodejs
        ctags
        tmux
        )

    for package in "${packages[@]}"; do
        if ! installed $package; then
            printf "\n${BLUE}Installing $package ${NC}\n\n"
            $INSTALL $package
        fi
    done
}

symlink_files_in_dir(){
    shopt -s dotglob
    for FILE in $DOTFILES/$1/*; do
        if [[ ${FILE##*/} == .zshenv ]]; then       # Setup for zsh should symlink .zshenv
            continue
        fi
        if [[ -f $HOME/${FILE##*/} ]]; then
            printf "\n${RED}Are you sure you want to override $HOME/${FILE##*/}? [y/n]: ${NC}"
            read -p "" confirm
            if [[ $confirm != 'y' && $confirm != 'Y' ]]; then
                continue
            fi
        fi
        printf "\n${BLUE}Setting up ${FILE##*/} ${NC}\n\n"
        ln -sf $FILE $HOME
    done
}

setup_home(){
    symlink_files_in_dir home
}

setup_git(){
    symlink_files_in_dir git
}

install_homebrew
install_packages
setup_home
setup_git
