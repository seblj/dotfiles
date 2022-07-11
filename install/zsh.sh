#!/bin/bash
# Installation of ZSH

source $HOME/dotfiles/install/utils.sh

# Install oh_my_zsh and plugins
install_oh_my_zsh(){
    printf "\n${BLUE}Installing OH_MY_ZSH ${NC}\n\n"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        printf "\n${BLUE}OH_MY_ZSH already installed ${NC}\n\n"
        return
    fi

    # Find out how to silence
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# Install spaceship prompt for oh_my_zsh
install_spaceship(){
    printf "\n${BLUE}Configuring prompt ${NC}\n\n"
    mkdir -p /usr/local/share/zsh/site-functions
    ln -sf $HOME/dotfiles/zsh/prompt/spaceship.zsh /usr/local/share/zsh/site-functions/prompt_spaceship_setup
}

setup_zsh(){
    printf "\n${BLUE}Setting up ZSH config ${NC}\n\n"
    chsh -s $(which zsh)
    ln -sf $HOME/dotfiles/home/.zshenv ~/
    ln -sf $HOME/dotfiles/zsh ~/.config/
}

install_zsh_async(){
    printf "\n${BLUE}Setting up async prompt ${NC}\n\n"
    cd $HOME/dotfiles/zsh/prompt
    git submodule update --init > /dev/null
}

install_zsh() {
    printf "\n${BLUE}Installing zsh ${NC}\n\n"
    $INSTALL zsh > /dev/null
}

install_zsh_z() {
    printf "\n${BLUE}Setting up z plugin for autojump ${NC}\n\n"
    mkdir -p $HOME/.config/z
    git clone --quiet https://github.com/agkozak/zsh-z.git $HOME/.oh-my-zsh/custom/plugins/zsh-z > /dev/null
}

install_zsh
install_zsh_async
install_oh_my_zsh
install_spaceship
install_zsh_z
setup_zsh