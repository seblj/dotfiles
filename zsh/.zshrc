# zmodload zsh/zprof

# Remove % at end of print when not using \n
PROMPT_EOL_MARK=""

# eval "$(starship init zsh)"
[ -z "$NVIM" ] && source $HOME/.config/zsh/vim.zsh
source $HOME/.config/zsh/exports.zsh
source $HOME/.config/zsh/spaceship.zsh
source $HOME/.config/zsh/completion.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/aliases.zsh

installed fnm && eval "$(fnm env --use-on-cd)"
installed pyenv && eval "$(pyenv init -)"
installed zoxide && eval "$(zoxide init --cmd cd zsh)"

[ -f ~/.linuxbrew/bin/brew ] && eval $(~/.linuxbrew/bin/brew shellenv)
[ -f /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.local.zsh ] && source ~/.local.zsh

# bun completions
[ -s "/Users/sebastian/.bun/_bun" ] && source "/Users/sebastian/.bun/_bun"

# zprof
