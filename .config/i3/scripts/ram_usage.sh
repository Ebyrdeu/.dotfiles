#!/usr/bin/env bash
# i3blocks: RAM usage based on MemAvailable (used = total - available).
# Shows used/total GiB and percentage. Click opens btop/htop/top.

set -euo pipefail

COLOR_OK="#cdd6f4"
COLOR_WARN="#f9e2af"
COLOR_HOT="#f38ba8"

ICON=""   # Nerd Font memory icon

supports_icons() {
  [[ -n "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" ]]
}

open_monitor() {
  if command -v btop >/dev/null 2>&1; then
    setsid -f btop >/dev/null 2>&1
  elif command -v htop >/dev/null 2>&1; then
    setsid -f htop >/dev/null 2>&1
  else
    setsid -f x-terminal-emulator -e top >/dev/null 2>&1 2>/dev/null || setsid -f xterm -e top >/dev/null 2>&1 || true
  fi
}

case "${BLOCK_BUTTON:-0}" in
  1|2|3) open_monitor ;;
esac

# Read meminfo (kB)
mt=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
ma=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
mu=$((mt - ma))

# Percentage
pct=$(( mu * 100 / mt ))

# GiB with one decimal
to_gib() { awk -v k="$1" 'BEGIN{printf "%.1f", k/1024/1024}'; }
used_gib=$(to_gib "$mu")
total_gib=$(to_gib "$mt")

if   (( pct >= 90 )); then color="$COLOR_HOT"
elif (( pct >= 70 )); then color="$COLOR_WARN"
else                      color="$COLOR_OK"
fi

icon="$ICON"; $(! supports_icons) && icon=""
full="${icon:+$icon }${pct}% (${used_gib}G/${total_gib}G)"
short="${pct}%"

echo "$full"
echo "$short"
echo "$color"
#!/usr/bin/env bash
# i3blocks: RAM usage based on MemAvailable (used = total - available).
# Shows used/total GiB and percentage. Click opens btop/htop/top.

set -euo pipefail

COLOR_OK="#cdd6f4"
COLOR_WARN="#f9e2af"
COLOR_HOT="#f38ba8"

ICON=""   # Nerd Font memory icon

supports_icons() {
  [[ -n "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" ]]
}

open_monitor() {
  if command -v btop >/dev/null 2>&1; then
    setsid -f btop >/dev/null 2>&1
  elif command -v htop >/dev/null 2>&1; then
    setsid -f htop >/dev/null 2>&1
  else
    setsid -f x-terminal-emulator -e top >/dev/null 2>&1 2>/dev/null || setsid -f xterm -e top >/dev/null 2>&1 || true
  fi
}

case "${BLOCK_BUTTON:-0}" in
  1|2|3) open_monitor ;;
esac

# Read meminfo (kB)
mt=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
ma=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
mu=$((mt - ma))

# Percentage
pct=$(( mu * 100 / mt ))

# GiB with one decimal
to_gib() { awk -v k="$1" 'BEGIN{printf "%.1f", k/1024/1024}'; }
used_gib=$(to_gib "$mu")
total_gib=$(to_gib "$mt")

if   (( pct >= 90 )); then color="$COLOR_HOT"
elif (( pct >= 70 )); then color="$COLOR_WARN"
else                      color="$COLOR_OK"
fi

icon="$ICON"; $(! supports_icons) && icon=""
full="${icon:+$icon }${pct}% (${used_gib}G/${total_gib}G)"
short="${pct}%"

echo "$full"
echo "$short"
echo "$color"
