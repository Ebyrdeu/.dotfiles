#!/usr/bin/env python3

import subprocess

def get_keyboard_layout():
    # Use subprocess to get the current keyboard layout
    result = subprocess.run(['xkblayout', 'print', '%s'], stdout=subprocess.PIPE, text=True)
    
    # The output is captured in result.stdout
    layout = result.stdout.strip()
    
    return layout

if __name__ == "__main__":
    layout = get_keyboard_layout()
    print(layout)

