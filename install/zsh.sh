#!/bin/bash
# Installation of ZSH

DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

# Install oh_my_zsh and plugins
install_oh_my_zsh(){
    printf "\n${BLUE}Installing OH_MY_ZSH ${NC}\n\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# Install spaceship prompt for oh_my_zsh
install_spaceship(){
    if [[ $ZSH_CUSTOM == "" ]]; then
        ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
    fi

    # Plugins
    printf "\n${BLUE}Cloning z plugin for autojump ${NC}\n\n"
    git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
    mkdir -p $HOME/.config/z

    printf "\n${BLUE}Configuring prompt ${NC}\n\n"
    sudo mkdir -p /usr/local/share/zsh/site-functions
    sudo ln -sf "$DOTFILES/zsh/prompt/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
}

setup_zsh(){
    chsh -s $(which zsh)
    if [[ -d $HOME/.config/zsh ]]; then
        printf "\n${RED}Are you sure you want to override $HOME/config/.zsh? [y/n]: ${NC}"
        read -p "" confirm
        if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
            printf "\n${BLUE}Setting up ZSH config ${NC}\n\n"
            ln -sf $DOTFILES/home/.zshenv ~/.zshenv
            ln -sf $DOTFILES/zsh ~/.config/zsh
        fi
    else
        ln -s $DOTFILES/zsh ~/.config/zsh
        if [[ -f $HOME/.zshenv ]]; then
            printf "\n${RED}Are you sure you want to override $HOME/.zshenv? [y/n]: ${NC}"
            read -p "" confirm
            if [[ $confirm == 'y' || $confirm == 'Y' ]]; then
                printf "\n${BLUE}$Setting up .zshenv ${NC}\n\n"
                ln -sf $DOTFILES/home/.zshenv ~/.zshenv
            fi
        else
            ln -sf $DOTFILES/home/.zshenv ~/.zshenv
        fi

    fi
}

install_zsh_async(){
    cd $DOTFILES/zsh/prompt
    rm -rf zsh-async
    git clone https://github.com/mafredri/zsh-async.git
}

install_zsh_async
install_oh_my_zsh
install_spaceship
setup_zsh
