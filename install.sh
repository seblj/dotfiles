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
    if [[ $OS == "Linux" ]]; then
        sudo apt-get update
        sudo snap install --edge nvim --classic

    elif [[ $OS == "Darwin" ]]; then
        brew install --HEAD luajit
        brew install --HEAD neovim
    fi
}

# Install vim plug for neovim
install_vim_plug(){
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

# Install oh_my_zsh and plugins
install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Hopefully fix insecure directories if there are any
    compaudit | xargs chmod g-w,o-w >/dev/null 2>&1

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
is_installed(){
    if [[ $OS == "Darwin" ]]; then
        if brew ls --versions $1 > /dev/null; then
            true
        else
            false
        fi
    elif [[ $OS == "Linux" ]]; then
        if dpkg -l $1; then
            true
        else
            false
        fi
    fi
}

# Install necessary dependencies if not already installed
install_packages(){
    packages=(
        zsh
        git
        gcc
        g++
        nodejs
        ctags
        tmux
        )

    for package in "${packages[@]}"; do
        if ! is_installed $package; then
            $INSTALL $package
        fi
    done
}

setup_neovim(){
    SOURCE=$PWD/
    DEST="$HOME/.config/"

    # Create directory if not exist
    mkdir -p ~/.config/nvim
    read -p "Do you want override current neovim configuration? [y/n] " confirm

    # Symlink files in nvim directory to correct location
    if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
        echo "Setting up neovim config"
        for d in nvim/* ; do
            ln -sf $SOURCE$d $DEST$d
        done
        echo "Done"
    fi

    nvim --headless +PlugInstall +qall >/dev/null 2>&1
}

setup_rest(){
    read -p "Do you want to override .zshrc, .gitconfig, .gitignore_global and .macos? [y/n] " confirm
    # Log files from z-plugin to .config
    mkdir -p $HOME/.config/z
    if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
        ln -sf $PWD/.macos $HOME
        ln -sf $PWD/.gitconfig $HOME
        ln -sf $PWD/.gitignore_global $HOME
        ln -sf $PWD/.zshrc $HOME
    fi
}

install_homebrew
install_neovim
install_vim_plug
install_packages
setup_neovim
install_oh_my_zsh
install_spaceship
setup_rest
