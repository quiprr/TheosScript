#!/bin/sh

# heavy thanks to kritanta for the baseline of this script.

NC='\033[0m'                            # No Color.

VI='\033[0;95m'                         # Violet.
YE='\033[1;93m'                         # Yellow.
CYA='\033[0;96m'                        # Cyan.
GR='\033[0;32m'                         # Green.
BAD='\033[0;91m'                        # Strong red. For errors.

command -v theos >/dev/null 2>&1 || commandinstalled="false"
if [[ $commandinstalled != "false" ]]; then
  echo -e "${CYA}The THEOS Command is already installed.${NC}" 
  exit 0
fi

nosudo() {
    echo "This cannot be ran as root or with sudo."
    exit 1
}

if [ $SHELL == "/bin/zsh" ]; then 
  profile="~/.zshrc"
else
  profile="~/.bashrc"
fi


crd=$PWD

[[ $UID == 0 || $EUID == 0 ]] && nosudo

sudo -p "Password for installation: " printf "" || exit 1

x=$PWD

need=""

command -v fakeroot >/dev/null 2>&1 || need+="fakeroot "
command -v curl >/dev/null 2>&1 || need+="curl "
command -v wget >/dev/null 2>&1 || need+="wget "
command -v git >/dev/null 2>&1 || need+="git "
command -v python >/dev/null 2>&1 || need+="python "
command -v perl >/dev/null 2>&1 || need+="perl"

iosInstall() {
    echo "This script is incompatable with iOS."
    exit 1
}

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
    distr=$(uname -s)
    arch=$(uname -p)
    if [ "$distr" == "Darwin" ]; then 
        if [ "$arch" == "arm" ] || [ "$arch" == "arm64" ]; then iosInstall
        else macosInstall
        fi
    else linuxInstall
    fi
    cd $HOME
    
    git clone https://github.com/monotrix/theosscript

    cd $HOME/theosscript

    sudo chmod +x ./theos

    if [ "$distr" == "Darwin" ]; then
      sudo ln ./theos /usr/local/bin/theos
    else sudo ln ./theos /usr/bin/theos
    fi 

    cd $x

    if [ "$THEOS_DEVICE_IP" == "" ]; then
      read -p "Enter your iPhone's IP Address (just press enter for none): " IP
      if [[ $IP != "" ]]; then
        echo "export THEOS_DEVICE_IP=$IP" >> $profile
        echo ""
        echo -e "${YE}The script will now set up ssh-copy-id. It will ask you some questions, make sure you answer them.${NC}"
        echo ""
        ssh-keygen
        ssh-copy-id root@$IP
        ssh-copy-id mobile@$IP

      fi
    fi

    if [[ $IP != "" ]]; then
      source $profile
    else
      echo "The THEOS Command has been installed."
    fi
}

script
