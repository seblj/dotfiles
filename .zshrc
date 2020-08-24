# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/oh-my-zsh"
ZSH_THEME="spaceship"


export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

#Remove % at end of print when not using \n
PROMPT_EOL_MARK=""

#Alias

alias vim="nvim"

#Change cursor
_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

plugins=(git zsh-z)

source $ZSH/oh-my-zsh.sh

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
  SPACESHIP_PROMPT_ORDER=(
  user
  time     #
  vi_mode  # these sections will be
  host     #
  char
  dir
  git
  node
  ruby
  xcode
  swift
  golang
  docker
  venv
  pyenv
)
# USER
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX="" # remove `with` before username
SPACESHIP_USER_SUFFIX=" " # remove space before host

# HOST
# Result will look like this:
#   username@:(hostname)
SPACESHIP_HOST_PREFIX="@:("
SPACESHIP_HOST_SUFFIX=") "

# DIR
SPACESHIP_DIR_PREFIX='' # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_TRUNC='1' # show only last directory
# SPACESHIP_DIR_TRUNC_REPO=false

# GIT
# Disable git symbol
# # Wrap git in `git:(...)`
SPACESHIP_GIT_PREFIX='➜ '
SPACESHIP_GIT_SUFFIX=" "
SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name
# Unwrap git status from `[...]`
# SPACESHIP_GIT_STATUS_PREFIX=""
# SPACESHIP_GIT_STATUS_SUFFIX=""


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias git-create="~/contributor/git_create/git_create.sh"
alias share="~/scripts/share.sh"
alias report="~/scripts/report.sh"
alias vmstart="VBoxManage startvm "Ubuntu" --type headless"
alias vmpause="VBoxManage controlvm "Ubuntu" pause --type headless"
alias vmresume"VBoxManage controlvm "Ubuntu" resume --type headless"
alias vmstop="VBoxManage controlvm "Ubuntu" poweroff --type headless"
alias weather="python3 ~/projects/weatherscrape.py"
alias table="python3 ~/projects/table.py"
alias icon="~/scripts/replace_icons.sh"
