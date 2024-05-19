#!/bin/bash

# Path to battery status file
BATTERY_PATH="~/sys/class/power_supply/BAT0"

# Read the battery capacity and status
CAPACITY=$(cat $BATTERY_PATH/capacity)
STATUS=$(cat $BATTERY_PATH/status)

# Display the battery status and capacity
if [ "$STATUS" == "Charging" ]; then
    echo "⚡ $CAPACITY%"
elif [ "$STATUS" == "Discharging" ]; then
    echo "🔋 $CAPACITY%"
else
    echo "🔌 $CAPACITY%"
fi

