#!/bin/bash

# Get the window ID of the YouTube Music app
win_id=$(xwininfo -tree -root | grep 'YouTube Music' | awk '{print $1}')

# Check if the window ID is not empty
if [ -n "$win_id" ]; then
    # Fetch the window title
    title=$(xprop -id "$win_id" WM_NAME | cut -d '"' -f 2)
    
    # Remove the suffix "- YouTube Music" from the title
    clean_title=$(echo "$title" | sed 's/ - YouTube Music$//')
    
    # Print the cleaned title
    echo "$clean_title"
else
    echo "YouTube Music not running"
fi

