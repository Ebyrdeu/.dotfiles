#!/usr/bin/env bash
# i3blocks: CPU usage (%). Calculates from /proc/stat with a small
# first-run sample, then uses a cache file for accurate deltas.
# Click: open btop/htop/top.

set -euo pipefail

SIGNAL=11
CACHE="/tmp/i3b-cpu-${UID}.cache"

# Colors (Catppuccin-ish)
COLOR_OK="#cdd6f4"
COLOR_WARN="#f9e2af"
COLOR_HOT="#f38ba8"

ICON=""   # Nerd Font; falls back to plain text if not supported

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

# Click handling
case "${BLOCK_BUTTON:-0}" in
  1|2|3) open_monitor ;;
esac

read_cpu() {
  # Fields: user nice system idle iowait irq softirq steal guest guest_nice
  # We use first 8 for total (exclude guest*)
  awk '/^cpu /{print $2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat
}

calc_usage() {
  # Arguments: prev_total prev_idle curr_total curr_idle
  local pt="$1" pi="$2" ct="$3" ci="$4"
  local dt=$((ct - pt))
  local di=$((ci - pi))
  if (( dt <= 0 )); then echo 0; return; fi
  awk -v dt="$dt" -v di="$di" 'BEGIN{printf "%d", (1 - di/dt)*100 + 0.5}'
}

# Get current totals
read -r u n s i io irq sirq st <<<"$(read_cpu)"
curr_total=$((u + n + s + i + io + irq + sirq + st))
curr_idle=$((i + io))

if [[ -f "$CACHE" ]]; then
  read -r prev_total prev_idle <"$CACHE" || { prev_total=0; prev_idle=0; }
  usage="$(calc_usage "$prev_total" "$prev_idle" "$curr_total" "$curr_idle")"
else
  # First run: quick sample for immediate reading
  sleep 0.2
  read -r u2 n2 s2 i2 io2 irq2 sirq2 st2 <<<"$(read_cpu)"
  ct2=$((u2 + n2 + s2 + i2 + io2 + irq2 + sirq2 + st2))
  ci2=$((i2 + io2))
  usage="$(calc_usage "$curr_total" "$curr_idle" "$ct2" "$ci2")"
  curr_total="$ct2"; curr_idle="$ci2"
fi

# Update cache
printf "%s %s\n" "$curr_total" "$curr_idle" >"$CACHE"

# Pick color
if   (( usage >= 85 )); then color="$COLOR_HOT"
elif (( usage >= 60 )); then color="$COLOR_WARN"
else                        color="$COLOR_OK"
fi

icon="$ICON"; $(! supports_icons) && icon=""
full="${icon:+$icon }${usage}%"
short="${usage}%"

echo "$full"
echo "$short"
echo "$color"
