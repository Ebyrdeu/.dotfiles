#!/bin/bash

# Set the locale to Japanese for date formatting
export LC_TIME=ja_JP.UTF-8

# Get the current time and date
current_time=$(date '+%H:%M:%S %d-%m-%Y')

# Map the abbreviated Japanese weekday names to Kanji
declare -A weekday_map=(
    ["月"]="月"
    ["火"]="火"
    ["水"]="水"
    ["木"]="木"
    ["金"]="金"
    ["土"]="土"
    ["日"]="日"
)

# Get the abbreviated weekday name in Japanese
weekday_japanese=$(date '+%a')

# Get the corresponding Kanji
weekday_kanji=${weekday_map[$weekday_japanese]}

# Format the output for i3blocks
output="($weekday_kanji) $current_time"

# Print the formatted date and time with the Kanji day of the week
echo "$output"

