#!/bin/bash
# Neovim installation

source ~/dotfiles/install/utils.sh

install_neovim_dependencies() {
    printf "\n${BLUE}Installing neovim dependencies ${NC}\n\n"
    case "$OS" in
    Linux*) sudo apt-get install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen >/dev/null ;;
    Darwin*) brew install ninja libtool cmake pkg-config gettext curl >/dev/null ;;
    *)
        echo "$OS not supported to download dependencies for neovim"
        return
        ;;
    esac
}

clone_neovim() {
    if [[ ! -d "$HOME/Applications/neovim" ]]; then
        printf "\n${BLUE}Cloning neovim ${NC}\n\n"
        git clone --quiet https://github.com/neovim/neovim.git $HOME/Applications/neovim >/dev/null
    fi
}

build_neovim() {
    if [[ ! -d "$HOME/Applications/neovim" ]]; then
        printf "\n${BLUE}Starting to build neovim ${NC}\n\n"
        cd ~/Applications/neovim
        make CMAKE_BUILD_TYPE=RelWithDebInfo >/dev/null
        sudo make install >/dev/null
    fi
}

setup_neovim() {
    printf "\n${BLUE}Setting up neovim config ${NC}\n\n"
    mkdir -p $HOME/.config
    ln -sf $HOME/dotfiles/nvim $HOME/.config
}

install_neovim_dependencies
clone_neovim
build_neovim
setup_neovim
