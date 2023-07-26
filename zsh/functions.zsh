# Functions

#Check if a package is installed
installed(){
    command -v "$1" >/dev/null 2>&1
}

# Compare commits
diff_commit() {
    if [ "$1" != "" ]
    then
        git diff $1~ $1
    else
        git diff HEAD~ HEAD
    fi
}

# TODO: Maybe add an override flag
git() {
    # If we are inside a git repo at work, and does not use -h or --help with
    # push, and the branch is either master or d2d, then refuse the push
    if [[ "$1" == "push" && "$@" != *"--help"* && "$@" != *"-h"* && $PWD == */work* && $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        branch=$(git rev-parse --abbrev-ref HEAD)
        if [[ $branch == *master* || $branch == *d2d* ]]; then
            echo "Do not push to master or d2d"
        else
            command git "$@"
        fi
    else
        command git "$@"
    fi
}

fzf_gitmoji() {
    local cmd="cat $HOME/dotfiles/zsh/gitmoji.json | jq -r '.[] | \"\(.emoji) \(.code) \(.description)\"'"
    local result="$(eval "$cmd" | fzf | xargs echo | grep -Eo ':\w+:')"

    zle reset-prompt
    [ -n "$result" ] && LBUFFER+=$result
}

zle -N fzf_gitmoji
installed zvm_bindkey && zvm_bindkey viins '^G' fzf_gitmoji
bindkey '^G' fzf_gitmoji

# Opens file in grammarly.
# Convert to txt temporarily since grammarly don't support .tex and .md
# Deletes file after opening, or on SIGINT.
# Sleep to allow grammarly to process the file before it is deleted
grammarly() {
    file=${1%.*}.txt
    trap 'rm file' INT
    cp $1 $file && open -a Grammarly $file && sleep 10s && rm $file
}

# Kill specified port
kill_port() {
    kill $(lsof -t -i:$1)
}

# Always zip recursively and change how zip command work
# Default to .zip with same name as folder/file
zip() {
    zipname=$1
    if [ $2 ] ; then
        case $2 in
            *.*)            zipname=$2 ;;
            *)              zipname=$2.zip ;;
        esac
    fi
    command zip -r $zipname $1
}

# Extract files
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1 ;;
            *.tar.gz)    tar xzf $1 ;;
            *.bz2)       bunzip2 $1 ;;
            *.rar)       rar x $1 ;;
            *.gz)        gunzip $1 ;;
            *.tar)       tar xf $1 ;;
            *.tbz2)      tar xjf $1 ;;
            *.tgz)       tar xzf $1 ;;
            *.zip)       unzip $1 ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1 ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Syncs pwd with a server over ssh
share() {
    if [ -z "$1" ]; then
        echo Specify a server and location, and it will sync pwd with the server
        exit 1
    fi

    rsync -avz -q -e "ssh" $PWD $1 &>/dev/null

    fswatch -r0 -Ie $PWD/4913 --event Created --event Updated --event Removed -0 $PWD | while read -d "" event; do

        rsync -avz -q -e "ssh" $PWD $1 &>/dev/null

    done &
}

install_neovim() {
    mkdir -p ~/Applications
    cd ~/Applications

    case "$OS" in
        Linux*) NVIM_DIR="nvim-linux64" ;;
        Darwin*) NVIM_DIR="nvim-macos" ;;
        *)
            echo "$OS not supported in function install_neovim"
            return ;;
    esac

    curl -LO https://github.com/neovim/neovim/releases/download/nightly/$NVIM_DIR.tar.gz
    tar xzf $NVIM_DIR.tar.gz
    rm $NVIM_DIR.tar.gz
    rm -rf nvim-nightly
    case "$OS" in
        Darwin*) NVIM_DIR="nvim-osx64" ;;
    esac
    mv ~/Applications/$NVIM_DIR ~/Applications/nvim-nightly

    cd -
}

install_packages(){
    p=""
    arr=("$@")
    for package in "${arr[@]}"; do
        p+="$package "
    done
    if [[ $p != "" ]]; then
        printf "\n${BLUE}Installing $p ${NC}\n\n"
        echo $p > /dev/null
    fi
}


test_install_packages(){
    packages=(
        zsh
        curl
        gcc
        g++
        git
        nodejs
        tmux
        ripgrep
    )
    # install_packages packages
    install_packages "${packages[@]}"
}
