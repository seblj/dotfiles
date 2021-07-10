# Spaceship theme for zsh

# Source async repo
source $ZDOTDIR/prompt/zsh-async/async.zsh

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
SPACESHIP_PROMPT_ORDER=(
  user
  host
  char
  dir
  git_branch
  git_status
  node
  docker
  venv
)

# VENV
SPACESHIP_VENV_GENERIC_NAMES=''
SPACESHIP_VENV_SYMBOL=' '
