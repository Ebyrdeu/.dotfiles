#!/bin/bash

get_youtube_music_window_id() {
    xwininfo -tree -root | rg -o '0x[0-9a-f]+.*YouTube Music' | awk '{print $1}'
}

get_window_title() {
    local win_id="$1"
    xprop -id "$win_id" WM_NAME | rg -o '"[^"]+"' | tr -d '"'
}

clean_title() {
    local title="$1"
    echo "$title" | sed 's/ - YouTube Music$//' | xargs
}

main() {
    win_id=$(get_youtube_music_window_id)
    
    if [[ -n "$win_id" ]]; then
        local retries=5
        local delay=0.2
        local title=""
        
        for ((i=0; i<retries; i++)); do
            title=$(get_window_title "$win_id")
            title=$(clean_title "$title")
            
            if [[ -n "$title" && "$title" != "YouTube Music" ]]; then
                echo "$title"
                return
            fi
            
            sleep "$delay"
        done
        
        echo ""
    else
        echo ""
    fi
}

main
