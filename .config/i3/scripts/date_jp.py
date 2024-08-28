#!/usr/bin/env python3

import locale
import datetime

# Set the locale to Japanese for date formatting
locale.setlocale(locale.LC_TIME, 'ja_JP.UTF-8')

# Get the current time and date
current_time = datetime.datetime.now().strftime('%H:%M:%S %d-%m-%Y')

# Map the abbreviated Japanese weekday names to Kanji (though they are the same)
weekday_map = {
    '月': '月',
    '火': '火',
    '水': '水',
    '木': '木',
    '金': '金',
    '土': '土',
    '日': '日'
}

# Get the abbreviated weekday name in Japanese
weekday_japanese = datetime.datetime.now().strftime('%a')

# Get the corresponding Kanji
weekday_kanji = weekday_map[weekday_japanese]

# Format the output for i3blocks
output = f"({weekday_kanji}) {current_time}"

# Print the formatted date and time with the Kanji day of the week
print(output)

