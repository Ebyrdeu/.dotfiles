#!/bin/bash

set -eE

ask_skip() {
    local section="$1"
    read -p "Do you want to skip $section? [y/N]: " answer
    answer=${answer:-N}
    [[ "$answer" =~ ^[Yy]$ ]]
}

echo "----------------------------------------"
echo " Starting Initial setup"
echo "----------------------------------------"
if ! ask_skip "Initial setup"; then
    source ~/.dotfiles/install/init/dirs.sh
    source ~/.dotfiles/install/init/multilib.sh
    source ~/.dotfiles/install/init/repo-add-color.sh
    source ~/.dotfiles/install/init/packages.sh
fi

echo "----------------------------------------"
echo "󰵮 Starting developer setup"
echo "----------------------------------------"
if ! ask_skip "Developer setup"; then
    source ~/.dotfiles/install/dev/docker.sh
    source ~/.dotfiles/install/dev/dev-env.sh
    source ~/.dotfiles/install/dev/jetbrains-idea.sh
fi

echo "----------------------------------------"
echo "󰹑 Starting WM setup"
echo "----------------------------------------"
if ! ask_skip "WM setup"; then
    source ~/.dotfiles/install/wm/wm.sh
    source ~/.dotfiles/install/wm/hy3.sh
fi

echo "----------------------------------------"
echo "󰻠 Starting System setup"
echo "----------------------------------------"
if ! ask_skip "System setup"; then
    source ~/.dotfiles/install/system/bluetooth.sh
    source ~/.dotfiles/install/system/firewall.sh
    source ~/.dotfiles/install/system/printer.sh
    source ~/.dotfiles/install/system/ssh-flakiness.sh
    source ~/.dotfiles/install/system/network.sh
fi

echo "----------------------------------------"
echo "󱘷 Post install setup"
echo "----------------------------------------"
if ! ask_skip "Post install setup"; then
    source ~/.dotfiles/install/post/cleanup.sh
fi
