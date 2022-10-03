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

# Colors
RED='\033[0;1;31m'
REDTHIN='\033[0;31m'
GREEN='\033[0;1;32m'
GREENTHIN='\033[0;32m'
YELLOW='\033[0;1;33m'
YELLOWTHIN='\033[0;33m'
BLUE='\033[0;1;34m'
NC='\033[0m'
UNDERLINE='\x1b[4m'
