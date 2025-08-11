#!/bin/bash

# Get the current brightness
brightness=$(brightnessctl get)

# Get the maximum brightness
max_brightness=$(brightnessctl max)

# Calculate the brightness percentage using integer arithmetic
percentage=$(( brightness * 100 / max_brightness ))

# Print the current brightness percentage
echo "󰃟 ${percentage}%"

