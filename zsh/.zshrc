# ZSH

echo -ne '\e[5 q'
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/.config/zsh/exports.zsh

# Remove % at end of print when not using \n
PROMPT_EOL_MARK=""

plugins=(git docker docker-compose)
if [ -z "$NVIM" ]; then
    source $HOME/.config/zsh/vim.zsh
fi

source $HOME/.config/zsh/exports.zsh
source $HOME/.config/zsh/completion.zsh
source $HOME/.config/zsh/keybinds.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/aliases.zsh

zstyle ':completion:*:*:*:*:*' menu select

# TODO: Automatically clone if not exists
source ~/.powerlevel10k/powerlevel10k.zsh-theme

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

[ -f ~/.linuxbrew/bin/brew ] && eval $(~/.linuxbrew/bin/brew shellenv)
[ -f /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
