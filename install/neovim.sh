#!/bin/bash
# Neovim installation

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

# Install neovim head
install_neovim(){
    printf "\n${BLUE}Installing Neovim HEAD ${NC}\n\n"

    mkdir -p ~/Applications
    cd ~/Applications

    case "$OS" in
        Linux*) NVIM_DIR="nvim-linux64";;
        Darwin*) NVIM_DIR="nvim-macos";;
        *) 
            echo "$OS not supported in function install_neovim"
            return;;
    esac

    curl -LO https://github.com/neovim/neovim/releases/download/nightly/$NVIM_DIR.tar.gz
    tar xzf $NVIM_DIR.tar.gz
    rm $NVIM_DIR.tar.gz
    rm -rf nvim-nightly
    case "$OS" in
        Darwin*) NVIM_DIR="nvim-osx64";;
    esac
    mv ~/Applications/$NVIM_DIR ~/Applications/nvim-nightly

    cd -
}

setup_neovim(){
    # Create directory if not exist
    mkdir -p $HOME/.config
    if [[ -d $HOME/.config/nvim ]]; then
        printf "\n${RED}Are you sure you want to override $HOME/.config/nvim? [y/n]: ${NC}"
        read -p "" confirm
        if [[ $confirm != 'y' && $confirm != 'Y' ]]; then
            return
        fi
    fi
    
    printf "\n${BLUE}Setting up Neovim config ${NC}\n\n"
    ln -sf $DOTFILES/nvim $HOME/.config
}

install_neovim
setup_neovim
