# Alias

alias cp="cp -i"
alias mv="mv -i"
alias f="find . |grep"

alias report="python3 ~/projects/scripts/latex_template.py"
alias submissions="python3 ~/projects/grader/grade.py"
alias weather="python3 ~/projects/weatherscrape.py"
alias table="python3 ~/projects/table.py"
alias icons="~/projects/scripts/replace_icons.sh"
alias cht="~/projects/scripts/cht.sh"

alias localip="ipconfig getifaddr en0"

# Avoid nesting
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim="nvr"
fi
