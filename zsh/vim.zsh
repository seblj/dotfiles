plugins+=(zsh-vi-mode)
ZVM_ESCAPE_KEYTIMEOUT=0.00

# Don't override fzf history widget
function zvm_after_init() {
  zvm_bindkey viins '^R' fzf-history-widget
}
