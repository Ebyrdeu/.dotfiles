#!/bin/bash

# Set locale and environment variables
export LC_ALL=en_US.UTF-8

# Get the battery number from the environment or default to 0
bat_number="${BLOCK_INSTANCE:-0}"

# Check if the battery exists by verifying the presence of the battery device in upower
battery_path="/org/freedesktop/UPower/devices/battery_BAT$bat_number"
if ! upower -i $battery_path &> /dev/null; then
  exit 0  # Exit silently if no battery is found
fi

# Get the battery percentage using upower
upower_output=$(upower -i $battery_path | rg 'percentage')
if [[ -z "$upower_output" ]]; then
  exit 0  # Exit silently if no battery percentage is found
fi
percent=$(echo "$upower_output" | rg -oP '\d+(?=%)')

# Get the battery state (charging, discharging, etc.)
bat_state=$(upower -i $battery_path | rg 'state')
status=$(echo "$bat_state" | awk '{print $2}')

# Check if we have a valid status and percentage
if [[ -z "$percent" || -z "$status" ]]; then
  exit 0  # Exit silently if the status or percentage is not valid
fi

full_text="${percent}%"

# Determine the status icon based on the state
if [[ "$status" == "discharging" ]]; then
  full_text+=" "
elif [[ "$status" == "charging" ]]; then
  full_text+=" "
elif [[ "$status" == "unknown" ]]; then
  ac_adapt=$(acpi -a)
  ac_status=$(echo "$ac_adapt" | awk '{print $3}')
  if [[ "$ac_status" == "on-line" ]]; then
    full_text+=" CHR"
  elif [[ "$ac_status" == "off-line" ]]; then
    full_text+=" DIS"
  fi
fi

short_text="$full_text"

# Determine the label based on battery percentage
if [[ $percent -lt 20 ]]; then
  label=""
elif [[ $percent -lt 45 ]]; then
  label=""
elif [[ $percent -lt 70 ]]; then
  label=""
elif [[ $percent -lt 95 ]]; then
  label=""
else
  label=""
fi

# Print the output for i3blocks
echo " $label $full_text"
echo " $label $short_text"

# Handle urgency and color based on the battery percentage if discharging
if [[ "$status" == "discharging" ]]; then
  if [[ $percent -lt 20 ]]; then
    echo "#ebdbb2"  # Gruvbox Red (Bright)
  elif [[ $percent -lt 40 ]]; then
    echo "#ebdbb2"  # Gruvbox Orange (Bright)
  elif [[ $percent -lt 60 ]]; then
    echo "#ebdbb2"  # Gruvbox Yellow (Bright)
  elif [[ $percent -lt 85 ]]; then
    echo "#ebdbb2"  # Gruvbox Green (Bright)
  fi

  # Set urgency flag if below 5%
  if [[ $percent -lt 5 ]]; then
    exit 33
  fi
fi

exit 0

