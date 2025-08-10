#!/usr/bin/env bash
# i3blocks volume block for PipeWire (wpctl)
# - Scroll up/down: volume ±5%
# - Left click: mute toggle
# - Middle click: open pavucontrol (if available)
# - Right click: cycle default sink
# - Sends i3blocks signal 10 to refresh instantly after actions

set -u
SIGNAL=10
SINK="@DEFAULT_AUDIO_SINK@"

# Colors (i3blocks hex)
COLOR_OK="#cdd6f4"
COLOR_WARN="#f9e2af"
COLOR_MUTED="#f38ba8"

# Pick icons (requires Nerd Fonts / Font Awesome)
ICON_MUTE=""
ICON_LOW=""
ICON_MED=""
ICON_HIGH=""

# Fallback to ASCII if font lacks icons
supports_icons() {
  # crude check: if locale/term can render, assume yes; otherwise let user override
  [[ -n "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" ]]
}

notify_blocks() {
  # Refresh i3blocks (non-fatal if not running)
  pkill -RTMIN+$SIGNAL i3blocks 2>/dev/null || true
}

open_mixer() {
  if command -v pavucontrol >/dev/null 2>&1; then
    pavucontrol >/dev/null 2>&1 &
  fi
}

# Cycle to next sink and make it default
cycle_sink() {
  # Parse sinks section from `wpctl status`
  mapfile -t sink_lines < <(wpctl status | awk '
    /Sinks:/ {inSinks=1; next}
    /Sources:/ {inSinks=0}
    inSinks {print}
  ')
  ((${#sink_lines[@]})) || exit 0

  # Current default sink id (line starting with '*')
  current_id=$(printf "%s\n" "${sink_lines[@]}" | awk '
    /^\s*\*/ { if (match($0, /([0-9]+)\./, m)) { print m[1]; exit } }
  ')

  # All sink ids in order
  mapfile -t ids < <(printf "%s\n" "${sink_lines[@]}" | awk '
    { if (match($0, /([0-9]+)\./, m)) print m[1] }
  ')

  (( ${#ids[@]} )) || exit 0

  # Find next index
  next="${ids[0]}"
  for i in "${!ids[@]}"; do
    if [[ "${ids[$i]}" == "$current_id" ]]; then
      next="${ids[$(( (i+1) % ${#ids[@]} ))]}"
      break
    fi
  done

  wpctl set-default "$next" >/dev/null 2>&1 || true
}

# Handle clicks from i3blocks
case "${BLOCK_BUTTON:-0}" in
  1) wpctl set-mute "$SINK" toggle >/dev/null 2>&1; notify_blocks ;;
  2) open_mixer; notify_blocks ;;
  3) cycle_sink; notify_blocks ;;
  4) wpctl set-volume -l 1.5 "$SINK" 5%+ >/dev/null 2>&1; notify_blocks ;; # allow up to 150%
  5) wpctl set-volume "$SINK" 5%-      >/dev/null 2>&1; notify_blocks ;;
  *) ;;
esac

# Read volume + mute state
out="$(wpctl get-volume "$SINK" 2>/dev/null || echo "")"
# Expected like: "Volume: 0.53 [MUTED]" or "Volume: 0.35"
vol_raw=$(echo "$out" | awk '{for(i=1;i<=NF;i++) if ($i ~ /^[0-9]*\.[0-9]+$/) {print $i; exit}}')
[[ -z "${vol_raw:-}" ]] && vol_raw="0"
percent=$(awk -v v="$vol_raw" 'BEGIN{printf("%d", v*100 + 0.5)}')
muted=$(echo "$out" | grep -q '\[MUTED\]' && echo 1 || echo 0)

# Choose icon
icon=""
if (( muted == 1 || percent == 0 )); then
  icon="$ICON_MUTE"
elif (( percent < 34 )); then
  icon="$ICON_LOW"
elif (( percent < 67 )); then
  icon="$ICON_MED"
else
  icon="$ICON_HIGH"
fi
$(! supports_icons) && icon="" # drop icons if desired

# Text lines for i3blocks
if (( muted == 1 )); then
  full="${icon:+$icon }${percent}%"
  short="${percent}%"
  color="$COLOR_MUTED"
elif (( percent >= 100 )); then
  full="${icon:+$icon }${percent}%"
  short="${percent}%"
  color="$COLOR_WARN"
else
  full="${icon:+$icon }${percent}%"
  short="${percent}%"
  color="$COLOR_OK"
fi

echo "$full"        # full_text
echo "$short"       # short_text
echo "$color"       # color
