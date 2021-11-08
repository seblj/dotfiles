# Dotfiles

This is my personal dotfiles for both Linux and macOS. I highly recommend to look through the dotfiles and use what you find interesting, instead of installing the entire config. If you however want to install the config, see section about installation.

## Installation

### Full

To setup the entire configuration, run the installation script `install.sh`. This will install ansible and run the ansible playbook `ansible/local.yml`

### Partial

It's also possible to run partial installation of the configuration. Make sure you have ansible installed for that.

#### Neovim config
##### This will clone neovim and build it from source as well. Neovim will be installed in `$HOME/Applications/neovim`.

- You can install my neovim config by running `ansible-playbook -K local.yml --tags nvim`

#### ZSH
##### This will install oh-my-zsh and some plugins for zsh. As well as linking up the zsh config.

- You can install my zsh config by running `ansible-playbook -K local.yml --tags zsh`

#### Link
##### This will link the neovim config, zsh config, and certain other config files to their correct location

- You can link the dotfiles by running `ansible-playbook -K local.yml --tags link`
