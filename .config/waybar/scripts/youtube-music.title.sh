#!/bin/bash

main() {
    # Get all clients and search for the YouTube Music title
    local clients=$(hyprctl clients)
    local title=$(echo "$clients" | awk -F': ' '
        BEGIN { found=0 }
        /title:/ { title=$2 }
        /class:/ { class=$2 }
        /^$/ { 
            if (title ~ / - YouTube Music$/ && class == "com.github.th_ch.youtube_music") {
                print title;
                exit
            }
        }
    ')

    if [[ -n "$title" ]]; then
        cleaned_title="${title% - YouTube Music}"
        # JSON output with text and icon
        echo "$cleaned_title"
    else
        # Empty JSON when nothing is playing
        echo "bruh"
    fi
}

main
