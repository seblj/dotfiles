#!/bin/bash
# Neovim installation

source $HOME/dotfiles/install/utils.sh

install_neovim_dependencies() {
    printf "\n${BLUE}Installing neovim dependencies ${NC}"
    case "$OS" in 
        Linux*) apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl > /dev/null;;
        Darwin*) brew install ninja libtool automake cmake pkg-config gettext curl > /dev/null;;
        *)
            echo "$OS not supported to download dependencies for neovim"
            return;;
    esac
}

clone_neovim(){
    printf "\n${BLUE}Cloning neovim ${NC}"
    mkdir -p ~/Applications
    cd ~/Applications

    git clone --quiet https://github.com/neovim/neovim.git > /dev/null
}

build_neovim(){
    printf "\n${BLUE}Starting to build neovim ${NC}"
    cd ~/Applications/neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo > /dev/null
    make install > /dev/null
}

setup_neovim(){
    printf "\n${BLUE}Setting up neovim config ${NC}\n\n"
    mkdir -p $HOME/.config
    ln -sf $HOME/dotfiles/nvim $HOME/.config
}

install_neovim_dependencies
clone_neovim
# build_neovim
setup_neovim
