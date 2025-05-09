#!/usr/bin/env bash

# Get current default sink
CURRENT_SINK=$(pactl get-default-sink)

# List all available sinks
SINKS=$(pactl list sinks short | awk '{print $2}')

# Convert to array and identify the next sink
SINK_LIST=($SINKS)
NUM_SINKS=${#SINK_LIST[@]}

# Find current sink index
INDEX=-1
for i in "${!SINK_LIST[@]}"; do
  if [[ "${SINK_LIST[$i]}" == "$CURRENT_SINK" ]]; then
    INDEX=$i
    break
  fi
done

# Calculate next sink index (loop back to 0 if at end)
NEXT_INDEX=$(( (INDEX + 1) % NUM_SINKS ))
NEXT_SINK=${SINK_LIST[$NEXT_INDEX]}

# Set new default sink and move all streams to it
pactl set-default-sink "$NEXT_SINK"
pactl list short sink-inputs | awk '{print $1}' | xargs -I{} pactl move-sink-input {} "$NEXT_SINK"

# Optional: Send notification
# notify-send "Audio Output Switched" "$NEXT_SINK"
