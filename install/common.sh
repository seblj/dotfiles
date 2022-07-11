#!/bin/bash

source $HOME/dotfiles/install/utils.sh

symlink_files_in_dir(){
    shopt -s dotglob
    for FILE in $HOME/dotfiles/$1/*; do
        printf "\n${BLUE}Setting up ${FILE##*/} ${NC}\n\n"
        ln -sf $FILE $HOME
    done
}

mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin

ln -sf $HOME/dotfiles/scripts/replace_icons.sh $HOME/.local/bin/icons

symlink_files_in_dir home
symlink_files_in_dir git
