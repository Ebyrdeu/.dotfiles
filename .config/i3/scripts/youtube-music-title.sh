#!/bin/bash

# Function to get the window ID of the YouTube Music app
get_youtube_music_window_id() {
    xwininfo_output=$(xwininfo -tree -root)
    echo "$xwininfo_output" | rg -o '0x[0-9a-f]+.*YouTube Music' | awk '{print $1}'
}

# Function to get the window title using the window ID
get_window_title() {
    local win_id="$1"
    xprop_output=$(xprop -id "$win_id" WM_NAME)
    echo "$xprop_output" | rg -o '"[^"]+"' | tr -d '"'
}

# Function to clean the title by removing the suffix "- YouTube Music"
clean_title() {
    local title="$1"
    echo "$title" | sed 's/ - YouTube Music$//'
}

# Main execution
main() {
    win_id=$(get_youtube_music_window_id)
    
    if [[ -n "$win_id" ]]; then
        title=$(get_window_title "$win_id")
        if [[ -n "$title" ]]; then
            clean_title_text=$(clean_title "$title")
            echo "$clean_title_text"
        else
            echo "Error: Could not retrieve window title."
        fi
    else
		echo ""
    fi
}

# Run the main function
main

