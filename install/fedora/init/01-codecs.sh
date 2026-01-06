#!/bin/bash


sudo dnf update '@core' '@multimedia' --exclude='PackageKit-gstreamer-plugin' --allowerasing && sync
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf install 'ffmpeg-libs'
sudo dnf install 'rpmfusion-free-release-tainted' 'rpmfusion-nonfree-release-tainted'
sudo dnf install 'libdvdcss'