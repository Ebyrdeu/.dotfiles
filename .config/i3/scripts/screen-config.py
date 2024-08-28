#!/usr/bin/env python3

import subprocess

def set_monitor_configuration():
    # Use subprocess to run the xrandr command to set up the monitor configuration
    command = [
        'xrandr',
        '--output', 'DP-0', '--off',
        '--output', 'DP-1', '--off',
        '--output', 'HDMI-0', '--off',
        '--output', 'DP-2', '--off',
        '--output', 'DP-3', '--off',
        '--output', 'HDMI-1', '--off',
        '--output', 'DP-4', '--primary', '--mode', '2560x1440', '--pos', '1920x0', '--rotate', 'normal',
        '--output', 'DP-5', '--off',
        '--output', 'None-1-1', '--off'
    ]
    
    # Execute the command
    subprocess.run(command)

if __name__ == "__main__":
    set_monitor_configuration()

