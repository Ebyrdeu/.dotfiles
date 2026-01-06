#!/bin/bash
echo "Set up keyring server"
sudo mkdir -p /etc/gnupg
sudo cp ~/.dotfiles/install/dev/gpg/dirmngr.conf /etc/gnupg/
sudo chmod 644 /etc/gnupg/dirmngr.conf
sudo gpgconf --kill dirmngr || true
sudo gpgconf --launch dirmngr || true
echo "Done"
