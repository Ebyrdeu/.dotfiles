#!/bin/bash

# Function to get the window ID of the YouTube Music app using hyprctl
get_youtube_music_window_id() {
    hyprctl clients | grep -B 4 "YouTube Music" | grep "Window" | awk '{print $2}'
}

# Function to get the window title using the window ID
get_window_title() {
    local win_id="$1"
    hyprctl clients | grep -A 10 "$win_id" | grep "title:" | awk -F 'title: ' '{print $2}'
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
        echo "Bruh"
    fi
}

# Run the main function
main
