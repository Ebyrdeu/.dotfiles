#!/usr/bin/env python3

import subprocess
import re

def get_youtube_music_window_id():
    """Gets the window ID of the YouTube Music app."""
    try:
        output = subprocess.run(['xwininfo', '-tree', '-root'], stdout=subprocess.PIPE, text=True).stdout
        match = re.search(r'0x[0-9a-f]+.*YouTube Music', output)
        if match:
            return match.group().split()[0]
    except Exception as e:
        print(f"Error: {e}")
        return None

def get_window_title(win_id):
    """Fetches the window title using the window ID."""
    try:
        output = subprocess.run(['xprop', '-id', win_id, 'WM_NAME'], stdout=subprocess.PIPE, text=True).stdout
        title_match = re.search(r'\"(.*)\"', output)
        if title_match:
            return title_match.group(1)
    except Exception as e:
        print(f"Error: {e}")
        return None

def clean_title(title):
    """Removes the suffix '- YouTube Music' from the title."""
    return re.sub(r' - YouTube Music$', '', title)

def main():
    win_id = get_youtube_music_window_id()
    
    if win_id:
        title = get_window_title(win_id)
        if title:
            clean_title_text = clean_title(title)
            print(clean_title_text)
        else:
            print("Error: Could not retrieve window title.")
    else:
        print("Bruh")

if __name__ == "__main__":
    main()

