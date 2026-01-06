#!/bin/bash

sudo rpm --import 'https://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-free-fedora-2020' && sync && sudo dnf install 'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-'$(rpm -E %fedora)'.noarch.rpm' -y && sync
sudo rpm --import 'https://rpmfusion.org/keys?action=AttachFile&do=get&target=RPM-GPG-KEY-rpmfusion-nonfree-fedora-2020' && sync && sudo dnf install 'https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-'$(rpm -E %fedora)'.noarch.rpm' -y && sync

sudo dnf update -y
