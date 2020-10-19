# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH=$PATH:~/programs/UPC/bin
export UPCXX_INSTALL="$HOME/programs/UPC"

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

#Remove % at end of print when not using \n
PROMPT_EOL_MARK=""

#Change cursor
# _fix_cursor() {
#    echo -ne '\e[5 q'
# }

# precmd_functions+=(_fix_cursor)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

plugins=(git zsh-z tmux)

# ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
  SPACESHIP_PROMPT_ORDER=(
  user
  time     #
  # vi_mode  # these sections will be
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




# Alias
alias vim="nvim"
alias cp="cp -i"
alias mv="mv -i"
alias fscluster="sshfs sjo207@uvcluster.cs.uit.no:/home/sjo207 $(pwd)"
alias git-create="~/contributor/git_create/git_create.sh"
alias share="~/scripts/share.sh"
alias report="~/scripts/report.sh"
alias report_latex="~/scripts/report_latex.sh"
alias vmstart="VBoxManage startvm "Ubuntu" --type headless"
alias vmpause="VBoxManage controlvm "Ubuntu" pause --type headless"
alias vmresume"VBoxManage controlvm "Ubuntu" resume --type headless"
alias vmstop="VBoxManage controlvm "Ubuntu" poweroff --type headless"
alias weather="python3 ~/projects/weatherscrape.py"
alias table="python3 ~/projects/table.py"
alias icon="~/scripts/replace_icons.sh"


# VI keybindings in shell
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
# bindkey '^r' history-incremental-search-backward

export KEYTIMEOUT=1
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

bindkey '^[[Z' reverse-menu-complete


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

