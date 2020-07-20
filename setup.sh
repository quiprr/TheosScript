#!/bin/bash

cd $HOME

sudo apt install fakeroot curl wget

cd $HOME/TheosScript

sudo chmod +x ./theos

sudo ln ./theos /usr/local/bin

read -p "Enter your iPhone's IP Address: " IP
echo "export THEOS_DEVICE_IP=${IP}" >> ~/.bashrc
echo "export THEOS_DEVICE_IP=${IP}" >> ~/.profile
echo ""

echo "The THEOS Command has been installed. Please restart your terminal to allow the variables to take effect."