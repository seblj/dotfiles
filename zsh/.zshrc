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

installed pyenv && eval "$(pyenv init -)"

[ -f ~/.linuxbrew/bin/brew ] && eval $(~/.linuxbrew/bin/brew shellenv)
[ -f /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.local.zsh ] && source ~/.local.zsh

eval "$(zoxide init --cmd cd zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/sebastian/.bun/_bun" ] && source "/Users/sebastian/.bun/_bun"

# fnm
FNM_PATH="/Users/sebastian/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="/Users/sebastian/Library/Application Support/fnm:$PATH"
    eval "`fnm env`"
fi

# zprof
