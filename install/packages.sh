#!/bin/bash
# Packages installation

# Install necessary dependencies if not already installed
install_packages(){
    packages=(
        zsh
        curl
        gcc
        g++
        git
        nodejs
        tmux
        ripgrep
    )

    for package in "${packages[@]}"; do
        if ! installed $package; then
            printf "\n${BLUE}Installing $package ${NC}\n\n"
            $INSTALL $package > /dev/null
        fi
    done
}

install_packages_mac(){
    packages=(
        fd
    )

    for package in "${packages[@]}"; do
        if ! installed $package; then
            printf "\n${BLUE}Installing $package ${NC}\n\n"
            $INSTALL $package > /dev/null
        fi
    done
}

install_packages_linux(){
    packages=(
        fd-find
    )

    for package in "${packages[@]}"; do
        if ! installed $package; then
            printf "\n${BLUE}Installing $package ${NC}\n\n"
            $INSTALL $package > /dev/null
        fi
    done
}

install_fzf() {
    printf "\n${BLUE}Installing fzf ${NC}\n\n"
    git clone --quiet https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish > /dev/null 2>&1
}

source $HOME/dotfiles/install/utils.sh

install_packages

if [[ $OS == 'Linux' ]]; then
    install_packages_linux
else
    install_packages_mac
fi

install_fzf

# Rust
printf "\n${BLUE}Installing rust ${NC}\n\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1

# Emojify
printf "\n${BLUE}Installing emojify ${NC}\n\n"
sh -c "curl -s https://raw.githubusercontent.com/mrowa44/emojify/master/emojify -o /usr/local/bin/emojify && chmod +x /usr/local/bin/emojify"

# Cargo is not exported into path right after installing, so just use fullpath
# for it

# Git delta
printf "\n${BLUE}Installing git-delta ${NC}\n\n"
$HOME/.cargo/bin/cargo install -q git-delta > /dev/null

# Stylua
printf "\n${BLUE}Installing stylua ${NC}\n\n"
$HOME/.cargo/bin/cargo install -q stylua > /dev/null


if [[ $OS == 'Linux' ]]; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null 2>&1
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update > /dev/null 2>&1
fi

$INSTALL gh > /dev/null 2>&1
