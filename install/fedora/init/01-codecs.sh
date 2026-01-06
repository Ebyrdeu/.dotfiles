#!/bin/bash

sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf update -y @core @multimedia --exclude=PackageKit-gstreamer-plugin --allowerasing
sudo dnf install -y libdvdcss ffmpeg-libs gstreamer1-plugin-openh264 mozilla-openh264