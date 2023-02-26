#!/bin/bash
# Installation of ZSH

source ~/dotfiles/install/utils.sh

# Install oh_my_zsh and plugins
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        printf "\n${BLUE}Installing OH_MY_ZSH ${NC}\n\n"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1
    fi
}

# Install spaceship prompt for oh_my_zsh
install_spaceship() {
    if [[ ! -d "$HOME/dotfiles/zsh/spaceship-prompt" ]]; then
        printf "\n${BLUE}Configuring prompt ${NC}\n\n"
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git $HOME/dotfiles/zsh/spaceship-prompt
        sudo mkdir -p /usr/local/share/zsh/site-functions
        sudo ln -sf $HOME/dotfiles/zsh/spaceship-prompt/spaceship.zsh /usr/local/share/zsh/site-functions/prompt_spaceship_setup
    fi
}

setup_zsh() {
    printf "\n${BLUE}Setting up ZSH config ${NC}\n\n"
    ln -sf $HOME/dotfiles/home/.zshenv ~/
    ln -sf $HOME/dotfiles/zsh ~/.config/
    chsh -s $(which zsh)
}

install_zsh() {
    if ! installed zsh; then
        printf "\n${BLUE}Installing zsh ${NC}\n\n"
        $INSTALL zsh >/dev/null
    fi
}

install_oh_my_zsh_plugins() {
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-z" ]]; then
        printf "\n${BLUE}Setting up z plugin for autojump ${NC}\n\n"
        mkdir -p $HOME/.config/z
        git clone --quiet https://github.com/agkozak/zsh-z.git $HOME/.oh-my-zsh/custom/plugins/zsh-z >/dev/null
    fi

    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode/" ]]; then
        printf "\n${BLUE}Setting up vim-mode plugin for zsh${NC}\n\n"
        git clone --quiet https://github.com/jeffreytse/zsh-vi-mode $HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode >/dev/null
    fi
}

install_zsh
install_oh_my_zsh
install_spaceship
install_oh_my_zsh_plugins
setup_zsh
