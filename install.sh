#!/bin/bash

set -eE

echo "----------------------------------------"
echo " Starting Initial setup"
echo "----------------------------------------"
source ~/.dotfiles/install/dirs.sh
source ~/.dotfiles/install/packages.sh


echo "----------------------------------------"
echo "󰵮 Starting developer setup"
echo "----------------------------------------"
source ~/.dotfiles/install/dev/docker.sh
source ~/.dotfiles/install/dev/rust.sh
source ~/.dotfiles/install/dev/sdkman.sh
source ~/.dotfiles/install/dev/jetbrains-idea.sh

echo "----------------------------------------"
echo "󰹑 Starting WM setup"
echo "----------------------------------------"
source ~/.dotfiles/install/wm.sh
source ~/.dotfiles/install/hy3.sh
