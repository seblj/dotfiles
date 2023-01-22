# Spaceship theme for zsh

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
SPACESHIP_PROMPT_ORDER=(
  user
  host
  dir
  git
  exec_time
  rust
  node
  docker
  venv
  char
)

SPACESHIP_USER_SHOW=always
SPACESHIP_GIT_PREFIX="→ "

# VENV
SPACESHIP_VENV_GENERIC_NAMES=''
SPACESHIP_VENV_SYMBOL=' '
