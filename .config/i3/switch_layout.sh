#!/bin/bash

# 1. sudo apt-get install x11-xkb-utils
# 2. chmod +x ~/.config/i3/switch_layout.sh

# Get the current layout
CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

# Define the layouts in the order you want to switch
LAYOUTS=("us" "ru" "se")

# Find the next layout
for i in "${!LAYOUTS[@]}"; do
    if [[ "${LAYOUTS[$i]}" == "$CURRENT_LAYOUT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#LAYOUTS[@]} ))
        NEXT_LAYOUT=${LAYOUTS[$NEXT_INDEX]}
        break
    fi
done

# Set the next layout
setxkbmap -layout $NEXT_LAYOUT

