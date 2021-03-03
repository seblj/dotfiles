# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

export _Z_DATA="$HOME/.config/z/.z."

# Path to your oh-my-zsh installation.
export PATH="/Users/sebastianlyngjohansen/Library/Python/3.9/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH=$PATH:~/Applications/UPC/bin
export UPCXX_INSTALL="$HOME/Applications/UPC"

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

plugins=(git zsh-z tmux)

# ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
  SPACESHIP_PROMPT_ORDER=(
  user
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
)
# USER
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX="" # remove `with` before username
SPACESHIP_USER_SUFFIX=" " # remove space before host
SPACESHIP_USER_COLOR="yellow"

# HOST
SPACESHIP_HOST_PREFIX="➜ "

# DIR
SPACESHIP_DIR_PREFIX='' # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_TRUNC='1' # show only last directory
SPACESHIP_DIR_COLOR="cyan"

# GIT
# Disable git symbol
SPACESHIP_GIT_PREFIX='➜ '
SPACESHIP_GIT_SUFFIX=" "
SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name

SPACESHIP_VENV_PREFIX='➜ ' 
SPACESHIP_VENV_SUFFIX=' ' 
SPACESHIP_VENV_GENERIC_NAMES=''
SPACESHIP_VENV_SYMBOL=' '
SPACESHIP_VENV_COLOR='#0087d7'

# Alias
alias nn="nvim"
alias vim="~/Applications/nvim-nightly/bin/nvim"
alias init.lua="vim ~/dotfiles/nvim/init.lua"
alias zshrc="vim ~/.zshrc"
alias cp="cp -i"
alias mv="mv -i"
alias uitvpn="~/projects/scripts/vpn/vpn.sh"
alias submissions=" python3 ~/projects/grader/grade.py"
alias share="~/scripts/share.sh"
alias report="python3 ~/projects/scripts/latex_template.py"
alias vmstart="VBoxManage startvm "Ubuntu" --type headless"
alias vmpause="VBoxManage controlvm "Ubuntu" pause --type headless"
alias vmresume"VBoxManage controlvm "Ubuntu" resume --type headless"
alias vmstop="VBoxManage controlvm "Ubuntu" poweroff --type headless"
alias weather="python3 ~/projects/weatherscrape.py"
alias table="python3 ~/projects/table.py"
alias icons="~/projects/scripts/replace_icons.sh"


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

# autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

