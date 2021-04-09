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
