#!/bin/bash

cd $HOME

git clone https://github.com/ajaidan0/TheosScript.git

cd $HOME/theosscript

sudo apt install fakeroot

sudo chmod +x ./theos

sudo ln ./theos /usr/bin