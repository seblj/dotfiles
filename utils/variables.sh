OS=$(uname -s)
INSTALL=""
UPDATE=""

# Determine if brew or apt should be used for packages
case "$OS" in
    Linux*)
        INSTALL="sudo apt-get install -y"
        UPDATE="sudo apt-get update";;
    Darwin*)
        INSTALL="brew install"
        UPDATE="brew update";;
esac

#Check if a package is installed
installed(){
    command -v "$1" >/dev/null 2>&1
}
