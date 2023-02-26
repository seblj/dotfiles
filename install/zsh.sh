#!/bin/bash
# Installation of ZSH

source ~/dotfiles/install/utils.sh

# Install oh_my_zsh and plugins
install_oh_my_zsh() {
    printf "\n${BLUE}Installing OH_MY_ZSH ${NC}\n\n"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        printf "\n${BLUE}OH_MY_ZSH already installed ${NC}\n\n"
        return
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1
}

# Install spaceship prompt for oh_my_zsh
install_spaceship() {
    printf "\n${BLUE}Configuring prompt ${NC}\n\n"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git $HOME/dotfiles/zsh/spaceship-prompt
    sudo mkdir -p /usr/local/share/zsh/site-functions
    sudo ln -sf $HOME/dotfiles/zsh/spaceship-prompt/spaceship.zsh /usr/local/share/zsh/site-functions/prompt_spaceship_setup
}

setup_zsh() {
    printf "\n${BLUE}Setting up ZSH config ${NC}\n\n"
    chsh -s $(which zsh)
    ln -sf $HOME/dotfiles/home/.zshenv ~/
    ln -sf $HOME/dotfiles/zsh ~/.config/
}

install_zsh() {
    printf "\n${BLUE}Installing zsh ${NC}\n\n"
    $INSTALL zsh >/dev/null
}

install_oh_my_zsh_plugins() {
    printf "\n${BLUE}Setting up z plugin for autojump ${NC}\n\n"
    mkdir -p $HOME/.config/z
    git clone --quiet https://github.com/agkozak/zsh-z.git $HOME/.oh-my-zsh/custom/plugins/zsh-z >/dev/null

    printf "\n${BLUE}Setting up vim-mode plugin for zsh${NC}\n\n"
    git clone --quiet https://github.com/jeffreytse/zsh-vi-mode $HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode >/dev/null
}

install_zsh
install_oh_my_zsh
install_spaceship
install_oh_my_zsh_plugins
setup_zsh
