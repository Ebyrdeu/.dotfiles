#!/usr/bin/env bash
# i3blocks: Show Wi-Fi SSID & signal strength using nmcli
# Click opens nmtui for network management

set -euo pipefail

ICON=""   # Nerd Font Wi-Fi icon
COLOR_OK="#cdd6f4"
COLOR_WARN="#f9e2af"
COLOR_BAD="#f38ba8"

supports_icons() {
  [[ -n "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" ]]
}

# Click = open nmtui
case "${BLOCK_BUTTON:-0}" in
  1|2|3) setsid -f x-terminal-emulator -e nmtui >/dev/null 2>&1 || true ;;
esac

# Get connection info
ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')
signal=$(nmcli -t -f active,signal dev wifi | awk -F: '$1=="yes"{print $2}')

if [[ -z "$ssid" ]]; then
  echo "No Wi-Fi"
  echo "No Wi-Fi"
  echo "$COLOR_BAD"
  exit 0
fi

# Choose color by signal
if   (( signal >= 70 )); then color="$COLOR_OK"
elif (( signal >= 40 )); then color="$COLOR_WARN"
else                          color="$COLOR_BAD"
fi

icon="$ICON"; $(! supports_icons) && icon=""
full="${icon:+$icon }${ssid} (${signal}%)"
short="${signal}%"

echo "$full"
echo "$short"
echo "$color"
