#!/bin/bash

# Function to get the current keyboard layout using xkblayout
get_keyboard_layout() {
    layout=$(xkblayout print '%s')
    echo "$layout"
}

# Main execution
layout=$(get_keyboard_layout)
echo "$layout"

