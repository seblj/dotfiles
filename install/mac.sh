
DOTFILES=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )
source $DOTFILES/utils/variables.sh
source $DOTFILES/utils/colors.sh

# Install homebrew if not already installed
install_homebrew(){
    if [[ $OS == "Darwin" ]]; then
        if ! installed brew; then
            printf "\n${BLUE}Installing homebrew ${NC}\n\n"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

    fi
}

symlink_macos(){
    if [[ $OS == "Darwin" ]]; then
        if [[ -f $HOME/.macos ]]; then
            printf "\n${RED}Are you sure you want to override $HOME/.macos? [y/n]: ${NC}"
            read -p "" confirm
            if [[ $confirm != 'y' && $confirm != 'Y' ]]; then
                return
            fi
        fi
        printf "\n${BLUE}Setting up .macos ${NC}\n\n"
        ln -sf $DOTFILES/mac/.macos $HOME
    fi
}

# TODO: Install casks in cask.sh

symlink_macos
install_homebrew
