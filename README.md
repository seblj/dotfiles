# Dotfiles

This is my personal dotfiles for both Linux and macOS. I highly recommend to look through the dotfiles and use what you find interesting, instead of installing the entire config. If you however want to install the config, see section about installation.

## Installation

### Full

To setup the entire configuration, run the installation script `install.sh`. This should prompt you with confirmation if needed to override the current configuration. Be careful if you don't want to lose the current config!

### Partial

It's also possible to run partial installation of the configuration. See directory `dotfiles/install` for those scripts.

#### `neovim.sh`

- This installs my neovim configuration which is located in `dotfiles/nvim`

#### `zsh.sh`

- This installs my shell setup with oh-my-zsh and spaceship theme. Config is located in `dotfiles/zsh`

#### `common.sh`

- This installs common packages and symlinks dotfiles from `dotfiles/home` and `dotfiles/git` to home
