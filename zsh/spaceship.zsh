# Spaceship theme for zsh

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
SPACESHIP_PROMPT_ORDER=(
  user
  host
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
)

SPACESHIP_CHAR_SYMBOL="→ "

# USER
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX="" # remove `with` before username
SPACESHIP_USER_SUFFIX=" " # remove space before host
SPACESHIP_USER_COLOR="yellow"

# HOST
SPACESHIP_HOST_PREFIX="→ "

# DIR
SPACESHIP_DIR_PREFIX='' # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_TRUNC='1' # show only last directory
SPACESHIP_DIR_COLOR="cyan"

# GIT
SPACESHIP_GIT_PREFIX='→ '
SPACESHIP_GIT_SUFFIX=" "
SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name

# VENV
SPACESHIP_VENV_PREFIX='→ ' 
SPACESHIP_VENV_SUFFIX=' ' 
SPACESHIP_VENV_GENERIC_NAMES=''
SPACESHIP_VENV_SYMBOL=' '
SPACESHIP_VENV_COLOR='#0087d7'
