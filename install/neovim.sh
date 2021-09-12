#!/bin/bash
# Neovim installation

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

# Install neovim appimage
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

clone_neovim(){
    case "$OS" in 
        Linux*) sudo apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl;;
        Darwin*) sudo port install ninja libtool autoconf automake cmake pkgconfig gettext;;
        *)
            echo "$OS not supported to download dependencies for neovim"
            return;;
    esac

    mkdir -p ~/Applications
    cd ~/Applications

    git clone https://github.com/neovim/neovim.git
}

build_neovim(){
    if [[ -d $HOME/Applications/neovim ]]; then
        printf "\n${BLUE}Starting to build neovim ${NC}"
        cd ~/Applications/neovim
        sudo make install
    else
        printf "\n${RED}Couldn't build neovim because $HOME/Applications/neovim was not found ${NC}"
    fi
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

# install_neovim
clone_neovim
build_neovim
setup_neovim
