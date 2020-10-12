#!/bin/sh

# heavy thanks to kritanta for the baseline of this script.

NC='\033[0m'                            # No Color.

VI='\033[0;95m'                         # Violet.
YE='\033[1;93m'                         # Yellow.
CYA='\033[0;96m'                        # Cyan.
GR='\033[0;32m'                         # Green.
BAD='\033[0;91m'                        # Strong red. For errors.

nosudo() {
    echo "This cannot be ran as root or with sudo."
    exit 1
}

if [ $SHELL == "/usr/bin/zsh" ]; then 
  profile="~/.zshrc"
else
  profile="~/.bashrc"
fi


crd=$PWD

[[ $UID == 0 || $EUID == 0 ]] && nosudo

sudo -p "Password for installation: " printf "" || exit 1

command -v theos >/dev/null 2>&1 || commandinstalled="false"

previousdir=$PWD

need=""

command -v fakeroot >/dev/null 2>&1 || need+="fakeroot "
command -v curl >/dev/null 2>&1 || need+="curl "
command -v wget >/dev/null 2>&1 || need+="wget "
command -v git >/dev/null 2>&1 || need+="git "
command -v python >/dev/null 2>&1 || need+="python "
command -v perl >/dev/null 2>&1 || need+="perl"

macosInstall() {
    command -v ldid >/dev/null 2>&1 || need+="ldid "
    command -v xz >/dev/null 2>&1 || need+="xz"
    if [ "$need" != "" ]; then
      read -p "Using Brew To Install Dependencies (${need}). Press Enter to Continue." || exit 1
      brew install $need
      echo -e "${GR}All dependencies installed successfully.${NC}"
    fi
}

linuxInstall() {
    command -v clang-6.0 >/dev/null 2>&1 || need+="clang-6.0 "
    if [ "$need" != "" ]; then
      read -p "Installing Dependencies (${need}). Press Enter to Continue." || exit 1
      if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $need || failedinstall=1
       elif [ -x "$(command -v apt-get)" ]; then sudo apt-get install $need || failedinstall=1
       elif [ -x "$(command -v dnf)" ];     then sudo dnf install $need || failedinstall=1
       elif [ -x "$(command -v zypper)" ];  then sudo zypper install $need || failedinstall=1
      else failedinstall=1;
      fi
      if [ $failedinstall == 1 ]; then
        echo -e "${BAD}You need to manually install:${NC} $need">&2; 
      else
        echo -e "${GR}All dependencies installed successfully.${NC}"
      fi
    fi
}

script() {
    if [ "$(uname -s)" == "Darwin" ]; then 
        if [ "$(uname -p)" == "arm" ] || [ "$(uname -p)" == "arm64" ]; then echo "This script is incompatable with iOS." exit 1
        else macosInstall
        fi
    else linuxInstall
    fi
    cd $HOME

    if [ "$commandinstalled" != "false" ]; then
        if [ "$(uname -s)" == "Darwin" ]; then
          sudo rm /usr/local/bin/theos
        else
          sudo rm /usr/bin/theos
        fi
        rm theosscript
    fi
    
    git clone https://github.com/monotrix/theosscript

    cd $HOME/theosscript

    sudo chmod +x ./theos

    if [ "$(uname -s)" == "Darwin" ]; then
      sudo ln -s ./theos /usr/local/bin/theos
    else sudo ln -s ./theos /usr/bin/theos
    fi 

    cd $previousdir
    echo "The THEOS Command has been installed."
}

script
