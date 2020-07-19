#!/bin/bash

cd $HOME

git clone https://github.com/ajaidan0/theosscript

cd $HOME/theosscript

sudo apt install fakeroot

sudo chmod +x ./theos

sudo ln -s $PROJECTS/theos/theos /usr/bin