# ZSH

source $HOME/.config/zsh/exports.zsh

#Remove % at end of print when not using \n
PROMPT_EOL_MARK=""
# ZSH_TMUX_AUTOSTART=true
ZSH_THEME="spaceship"

plugins=(git zsh-z tmux)

# Only try to source if dir exists. Should be set to path of .oh-my-zsh
if [[ -d $ZSH ]]; then
    source $ZSH/oh-my-zsh.sh
    source $HOME/.config/zsh/spaceship.zsh
fi

source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/vim.zsh

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval export PATH="/Users/sebastianlyngjohansen/.jenv/shims:${PATH}"
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME
source '/usr/local/Cellar/jenv/0.5.4/libexec/libexec/../completions/jenv.zsh'
jenv rehash 2>/dev/null
jenv refresh-plugins
jenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}
