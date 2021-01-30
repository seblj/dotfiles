#!/bin/bash
OS=$(uname -s)
INSTALL=""

# Determine if brew or apt should be used for packages
case "$OS" in
    Linux*)   INSTALL="sudo apt-get install" ;;
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
        sudo snap install --edge nvim --classic

    elif [[ $OS == "Darwin" ]]; then
        brew install --HEAD luajit
        brew install --HEAD neovim
    fi
}

# Install vim plug
install_vim_plug(){
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

# Install oh_my_zsh
install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install spaceship prompt for oh_my_zsh
install_spaceship(){
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    mkdir -p /usr/local/share/zsh/site-functions
    ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
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
        curl
        )

    for package in "${packages[@]}"; do
        if ! is_installed $package; then
            $INSTALL $package
        else
            echo "$package already installed"
        fi
    done
}

setup_neovim(){
    SOURCE=$PWD/
    DEST="/.config/"

    # Create directory if not exist
    mkdir -p ~/.config/nvim
    read -p "Do you want override current neovim configuration? [y/n]: " confirm

    # Symlink files in nvim directory to correct location
    if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
        echo "Setting up neovim config"
        for d in nvim/* ; do
            ln -sf $SOURCE$d $HOME$DEST$d
        done
        echo "Done"
    fi
}

setup_rest(){
    read -p "Do you want to override .zshrc, .gitconfig, .gitignore_global and .macos? [y/n] " confirm
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
setup_rest
install_oh_my_zsh
install_spaceship
