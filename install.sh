#!/bin/bash
OS=$(uname -s)
INSTALL=""

# Determine if brew or apt should be used for packages
case "$OS" in
    Linux*)   INSTALL="sudo apt-get install -y" ;;
    Darwin*)  INSTALL="brew install" ;;
esac

# Install homebrew if not already installed
install_homebrew(){
    if [[ $OS == "Darwin" ]]; then
        command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Install neovim head
install_neovim(){
    mkdir -p ~/programs
    cd ~/programs

    if [[ $OS == "Linux" ]]; then
        sudo apt-get update
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
        tar xzf nvim-linux64.tar.gz
        rm nvim-linux64.tar.gz
        mv ~/programs/nvim-linux64 ~/programs/nvim-nightly

    elif [[ $OS == "Darwin" ]]; then
        brew install --HEAD luajit
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
        tar xzf nvim-macos.tar.gz
        rm nvim-macos.tar.gz
        mv ~/programs/nvim-osx-64 ~/programs/nvim-nightly
    fi

    cd -
}

# Package manager for vim
install_packer(){
    git clone https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
}

# Install oh_my_zsh and plugins
install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# Install spaceship prompt for oh_my_zsh
install_spaceship(){
    if [[ $ZSH_CUSTOM == "" ]]; then
        ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
    fi

    # Plugins
    git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    sudo ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    sudo mkdir -p /usr/local/share/zsh/site-functions
    sudo ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
}

#Check if a package is installed
installed(){
    command -v "$1" >/dev/null 2>&1
}

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
            $INSTALL $package
        fi
    done
}

setup_neovim(){
    SOURCE=$(pwd)
    DEST="$HOME/.config"

    # Create directory if not exist
    mkdir -p ~/.config/nvim
    read -p "Do you want override current neovim configuration? [y/n] " confirm

    # Symlink files in nvim directory to correct location
    if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
        echo "Setting up neovim config"
        for d in nvim/* ; do
            ln -sf $SOURCE/$d $DEST/$d
        done
        echo "Done"
    fi
}

setup_rest(){
    SOURCE=$(pwd)
    read -p "Do you want to override .zshrc, .gitconfig, .gitignore_global and .macos? [y/n] " confirm
    # Log files from z-plugin to .config
    mkdir -p $HOME/.config/z
    if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
        ln -sf $SOURCE/.macos $HOME
        ln -sf $SOURCE/.gitconfig $HOME
        ln -sf $SOURCE/.gitignore_global $HOME
        ln -sf $SOURCE/.zshrc $HOME
    fi
}

# Hopefully fix insecure directories if there are any
/bin/zsh -i -c compaudit | xargs chmod g-w,o-w >/dev/null 2>&1

install_homebrew
install_neovim
install_packer
install_packages
setup_neovim
install_oh_my_zsh
install_spaceship
setup_rest
