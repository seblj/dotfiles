# Alias

alias cp="cp -i"
alias mv="mv -i"
alias f="find . |grep"

alias vmstart="VBoxManage startvm "Ubuntu" --type headless"
alias vmpause="VBoxManage controlvm "Ubuntu" pause --type headless"
alias vmresume"VBoxManage controlvm "Ubuntu" resume --type headless"
alias vmstop="VBoxManage controlvm "Ubuntu" poweroff --type headless"

alias report="python3 ~/projects/scripts/latex_template.py"
alias submissions="python3 ~/projects/grader/grade.py"
alias uitvpn="~/projects/scripts/vpn/vpn.sh"
alias weather="python3 ~/projects/weatherscrape.py"
alias table="python3 ~/projects/table.py"
alias icons="~/projects/scripts/replace_icons.sh"

# Avoid nesting
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias vim="nvr"
fi
