#!/bin/bash

# Function to set the monitor configuration using xrandr
set_monitor_configuration() {
    xrandr --output DP-0 --off \
           --output DP-1 --off \
           --output HDMI-0 --off \
           --output DP-2 --off \
           --output DP-3 --off \
           --output HDMI-1 --off \
           --output DP-4 --primary --mode 2560x1440 --pos 1920x0 --rotate normal \
           --output DP-5 --off \
           --output None-1-1 --off
}

# Main execution
set_monitor_configuration

