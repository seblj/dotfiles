#!/bin/bash
# Setup macos

source ~/dotfiles/install/utils.sh

if ! installed brew; then
    printf "\n${BLUE}Installing homebrew ${NC}\n\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >/dev/null
fi

printf "\n${BLUE}Setting up karabiner ${NC}\n\n"
brew install --cask karabiner-elements >/dev/null
ln -sf $HOME/dotfiles/karabiner $HOME/.config

printf "\n${BLUE}Setting up hammerspoon ${NC}\n\n"
brew install --cask hammerspoon >/dev/null
rm -rf $HOME/dotfiles/.hammerspoon
ln -sf $HOME/dotfiles/hammerspoon $HOME/.hammerspoon

ln -sf $HOME/dotfiles/mac/.macos $HOME
