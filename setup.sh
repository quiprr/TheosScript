#!/bin/sh

# heavy thanks to kritanta for the baseline of this script.

NC='\033[0m'                            # No Color.

VI='\033[0;95m'                         # Violet.
YE='\033[1;93m'                         # Yellow.
CYA='\033[0;96m'                        # Cyan.
GR='\033[0;32m'                         # Green.
BAD='\033[0;91m'                        # Strong red. For errors.

x=$PWD

need=""

command -v fakeroot >/dev/null 2>&1 || need+="fakeroot "
command -v curl >/dev/null 2>&1 || need+="curl "
command -v wget >/dev/null 2>&1 || need+="wget "
command -v git >/dev/null 2>&1 || need+="git "

iosInstall() {
    echo "This script is incompatable with iOS."
    exit 1
}

macosInstall() {
    command -v ldid >/dev/null 2>&1 || need+="ldid "
    command -v xz >/dev/null 2>&1 || need+="xz "
    if [ "$need" != "" ]; then
      read -p "Using Brew To Install Dependencies (${need}). Press Enter to Continue." || exit 1
      brew install $need
    fi
}

linuxInstall() {
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
      fi
    fi
}

script() {
    distr=$(uname -s)
    arch=$(uname -p)
    if [ "$distr" == "Darwin" ]; then 
        if [ "$arch" == "arm" ] || [ "$arch" == "arm64" ]; then iosInstall
        else macosInstall
        fi
    else linuxInstall
    fi
    cd $HOME

    cd $HOME/theosscript

    sudo chmod +x ./theos

    sudo ln ./theos /usr/local/bin

    read -p "Enter your iPhone's IP Address (just press enter for none): " IP
    if [[ $IP != "" ]]; then
      echo "export THEOS_DEVICE_IP=$IP" >> ~/.bashrc
      echo "export THEOS_DEVICE_IP=$IP" >> ~/.profile
      echo ""

      echo "The THEOS Command has been installed. Please restart your terminal to allow the variables to take effect."
    else
      echo "The THEOS Command has been installed."
    fi
    cd $x
}

script
