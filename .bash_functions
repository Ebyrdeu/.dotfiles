# ------------------------------------------------------------
# Pretty helpers
# ------------------------------------------------------------
__c_reset='\033[0m'; __c_green='\033[0;32m'; __c_yellow='\033[1;33m'; __c_red='\033[0;31m'; __c_cyan='\033[1;36m'
__say() { printf "%b%s%b\n" "$__c_cyan" "$*" "$__c_reset"; }
__ok()  { printf "%b%s%b\n" "$__c_green" "$*" "$__c_reset"; }
__warn(){ printf "%b%s%b\n" "$__c_yellow" "$*" "$__c_reset"; }
__err() { printf "%b%s%b\n" "$__c_red"   "$*" "$__c_reset" >&2; }

# ============================================================
# ex — extract archives smartly
#   ex [-d DIR] file1 [file2 ...]
#   Creates DIR if needed; defaults to current dir.
#   For multi-file calls, each file extracts into its own folder.
# ============================================================
ex() {
  local dest="" one_dest=0
  while getopts ":d:" opt; do
    case "$opt" in
      d) dest="$OPTARG";;
      *) __err "Usage: ex [-d DIR] <file1> [file2 ...]"; return 1;;
    esac
  done
  shift $((OPTIND-1))

  if (($# == 0)); then
    cat <<'EOF'
Usage: ex [-d DIR] <path/file>...
Supported: zip, rar, bz2, gz, tar, tbz2, tgz, Z, 7z, xz, tar.bz2, tar.gz, tar.xz,
           zlib, cso, zst, tar.zst, cpio, ace, zpaq, arc, dmg, iso, deb, rpm, apk, cab...
Tip: When extracting multiple files, each will go to its own subfolder.
EOF
    return 1
  fi

  # Make destination if provided
  if [[ -n "$dest" ]]; then
    mkdir -p -- "$dest" || { __err "Cannot create dest: $dest"; return 1; }
    one_dest=1
  fi

  local f base outdir
  shopt -s nocasematch
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      __err "'$f' does not exist"; continue
    fi
    base="$(basename -- "$f")"
    outdir="${base%.*}"
    [[ "$base" =~ \.tar\.(gz|bz2|xz|zst)$ ]] && outdir="${base%.tar.*}"
    [[ "$base" =~ \.(tbz2|tgz|txz)$ ]] && outdir="${base%.*}"

    # If not a single destination for all, use per-file folder
    local target="$PWD"
    if (( one_dest )); then
      target="$dest"
    else
      target="$PWD/$outdir"
      mkdir -p -- "$target"
    fi

    __say "Extracting: $base → $target"
    case "$base" in
      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) tar --auto-compress -xvf "$f" -C "$target" ;;
      *.lzma)      unlzma "$f" ;;
      *.bz2)       bunzip2 "$f" ;;
      *.cbr|*.rar) command -v unrar >/dev/null || { __err "unrar missing"; continue; }; unrar x -ad "$f" "$target/" ;;
      *.gz)        gunzip "$f" ;;
      *.cbz|*.epub|*.zip) unzip -d "$target" "$f" ;;
      *.z)         uncompress "$f" ;;
      *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                   command -v 7z >/dev/null || { __err "p7zip (7z) missing"; continue; }; 7z x "$f" -o"$target" ;;
      *.xz)        unxz "$f" ;;
      *.exe)       command -v cabextract >/dev/null || { __err "cabextract missing"; continue; }; cabextract -d "$target" "$f" ;;
      *.cpio)      (cd "$target" && cpio -id < "$f") ;;
      *.cba|*.ace) command -v unace >/dev/null || { __err "unace missing"; continue; }; unace x "$f" "$target" ;;
      *.zpaq)      command -v zpaq >/dev/null || { __err "zpaq missing"; continue; }; zpaq x "$f" -to "$target" ;;
      *.arc)       command -v arc >/dev/null  || { __err "arc missing";  continue; }; arc e "$f" ;;
      *.cso)       command -v ciso >/dev/null || { __err "ciso missing"; continue; }; ciso 0 "$f" "$target/${base}.iso" && ex "$target/${base}.iso" && rm -f "$f" ;;
      *.zlib)      command -v zlib-flate >/dev/null || { __err "zlib-flate missing"; continue; }; zlib-flate -uncompress < "$f" > "$target/${base%.*zlib}" && rm -f "$f" ;;
      *.dmg)       command -v hdiutil >/dev/null || { __err "hdiutil (macOS) missing"; continue; }; mnt_dir=$(mktemp -d); hdiutil mount "$f" -mountpoint "$mnt_dir"; __ok "Mounted at: $mnt_dir" ;;
      *.tar.zst)   tar -I zstd -xvf "$f" -C "$target" ;;
      *.zst)       zstd -d "$f" -o "$target/${base%.zst}" ;;
      *)           __warn "Unknown archive type: $f"; continue ;;
    esac
    __ok "Done: $base"
  done
  shopt -u nocasematch
}

# ============================================================
# connect — friendly Wi-Fi picker via nmcli (uses fzf if present)
#   connect [--if IFACE] [--ssid NAME] [--auto]
#   - Enter to pick; strongest suggested; hidden SSIDs labeled.
# ============================================================
connect() {
  local iface="" wanted_ssid="" auto=0
  while (($#)); do
    case "$1" in
      --if|--iface) iface="$2"; shift 2;;
      --ssid)       wanted_ssid="$2"; shift 2;;
      --auto)       auto=1; shift;;
      -h|--help)    echo "Usage: connect [--if IFACE] [--ssid NAME] [--auto]"; return 0;;
      *)            __err "Unknown option: $1"; return 1;;
    esac
  done

  __say "Rescanning Wi-Fi…"
  if [[ -n "$iface" ]]; then
    nmcli device wifi rescan ifname "$iface" >/dev/null 2>&1
  else
    nmcli device wifi rescan >/dev/null 2>&1
  fi

  # SSID:SECURITY:SIGNAL:BSSID
  mapfile -t rows < <(nmcli -t -f SSID,SECURITY,SIGNAL,BSSID device wifi list | grep -v '^--' || true)
  ((${#rows[@]})) || { __err "No Wi-Fi networks detected."; return 1; }

  # Deduplicate by SSID, keep the row with max SIGNAL
  declare -A bestRow bestSig
  local r ssid sec sig bssid
  for r in "${rows[@]}"; do
    IFS=":" read -r ssid sec sig bssid <<<"$r"
    [[ -z "$ssid" ]] && ssid="<Hidden SSID>"
    [[ -z "${bestSig[$ssid]}" || "$sig" -gt "${bestSig[$ssid]}" ]] && { bestSig[$ssid]="$sig"; bestRow[$ssid]="$ssid:$sec:$sig:$bssid"; }
  done

  # Build a menu (sorted by signal desc)
  mapfile -t menu < <(
    for k in "${!bestRow[@]}"; do
      IFS=":" read -r ssid sec sig bssid <<<"${bestRow[$k]}"
      printf "%03d%%  %-32s  %s  %s\n" "$sig" "$ssid" "$sec" "$bssid"
    done | sort -r
  )

  # If a SSID was provided, try to connect immediately
  if [[ -n "$wanted_ssid" ]]; then
    __say "Connecting to SSID: $wanted_ssid"
    if [[ -n "$iface" ]]; then
      nmcli --ask device wifi connect "$wanted_ssid" ifname "$iface"
    else
      nmcli --ask device wifi connect "$wanted_ssid"
    fi
  else
    local chosen
    if command -v fzf >/dev/null 2>&1; then
      chosen="$(printf '%s\n' "${menu[@]}" | fzf --prompt='Wi-Fi › ' --height 40% --reverse --border --ansi || true)"
    else
      __say "Available Wi-Fi (Signal  SSID  Security  BSSID)"
      printf "%s\n" "${menu[@]}"
      if ((auto)); then
        chosen="${menu[0]}"
        __warn "Auto mode: selecting strongest network."
      else
        read -r -p "Pick by typing the full line or press Enter for strongest: " chosen
        [[ -z "$chosen" ]] && chosen="${menu[0]}"
      fi
    fi
    [[ -z "$chosen" ]] && { __warn "Cancelled."; return 0; }
    # Extract SSID (column starts at position 8 after percentage)
    local chosen_ssid
    chosen_ssid="$(echo "$chosen" | sed -E 's/^[0-9]{3}%[[:space:]]+([^[:space:]][^ ]([^ ]|[ ](?![ ]{2}))+).*/\1/' | sed 's/[[:space:]]+$//')"
    [[ -z "$chosen_ssid" ]] && { __err "Could not parse selection."; return 1; }
    __say "Connecting to: $chosen_ssid"
    if [[ -n "$iface" ]]; then
      nmcli --ask device wifi connect "$chosen_ssid" ifname "$iface"
    else
      nmcli --ask device wifi connect "$chosen_ssid"
    fi
  fi

  if nmcli -t -f ACTIVE,SSID device wifi | grep -q '^yes:'; then
    local current; current="$(nmcli -t -f ACTIVE,SSID device wifi | awk -F: '/^yes:/{print $2; exit}')"
    __ok "Connected to: $current"
  else
    __err "Connection attempt finished, but no active Wi-Fi reported."
    return 1
  fi
}

# ============================================================
# sysinfo — concise, colored system overview
#   sysinfo [--no-color]
# ============================================================
sysinfo() {
  local use_color=1
  [[ "${1:-}" == "--no-color" ]] && use_color=0

  local C R; if ((use_color)); then C="$__c_cyan"; R="$__c_reset"; else C=""; R=""; fi

  # OS
  local os; if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    os="${NAME:-Linux} ($(uname -m))"
  else
    os="$(uname -s) $(uname -m)"
  fi

  # Host
  local host_model="Unknown"
  if [[ -r /sys/class/dmi/id/product_name ]]; then
    host_model="$(< /sys/class/dmi/id/product_name)"
    [[ -r /sys/class/dmi/id/product_version ]] && host_model+=" $(< /sys/class/dmi/id/product_version)"
  fi

  # Kernel
  local kernel="Linux $(uname -r)"

  # Uptime
  local up_s hours mins
  up_s=$(awk '{print int($1)}' /proc/uptime)
  hours=$((up_s/3600)); mins=$(((up_s%3600)/60))
  local uptime=""; ((hours>0)) && uptime+="${hours} hour$([[ $hours -ne 1 ]] && echo s)"
  ((hours>0 && mins>0)) && uptime+=", "
  ((mins>0)) && uptime+="${mins} min$([[ $mins -ne 1 ]] && echo s)"

  # Packages
  local pkg_count="N/A"
  if command -v pacman >/dev/null 2>&1; then
    pkg_count="$(pacman -Q 2>/dev/null | wc -l | tr -d ' ') (pacman)"
  fi

  # Shell
  local shell="unknown"
  if [[ -n "$BASH_VERSION" ]]; then
    shell="bash $BASH_VERSION"
  else
    shell="$(basename -- "$SHELL")"
  fi

  # Desktop/WM
  local desktop="N/A"
  [[ -n "$XDG_CURRENT_DESKTOP" ]] && desktop="$XDG_CURRENT_DESKTOP"
  [[ -n "$DESKTOP_SESSION" && "$desktop" == "N/A" ]] && desktop="$DESKTOP_SESSION"

  # CPU
  local cpu_model cpu_cores cpu_speed
  cpu_model="$(awk -F: '/model name/ {gsub(/^ +/,"",$2); print $2; exit}' /proc/cpuinfo)"
  cpu_cores="$(grep -c '^processor' /proc/cpuinfo)"
  cpu_speed="$(awk -F: '/cpu MHz/ {printf "%.2f",$2/1000; exit}' /proc/cpuinfo)"
  [[ -z "$cpu_speed" ]] && cpu_speed="N/A"
  local cpu="${cpu_model:-N/A} (${cpu_cores:-?}) @ ${cpu_speed} GHz"

  # GPU (first)
  local gpu; gpu="$(lspci 2>/dev/null | grep -iE 'vga|3d|display' | sed -E 's/.*: //; s/\(.*\)//' | head -n1)"
  [[ -z "$gpu" ]] && gpu="N/A"

  # Memory
  # Use /proc/meminfo for accuracy; show used = MemTotal - MemAvailable
  local mt ma mu mem_p
  mt=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)      # kB
  ma=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)  # kB
  mu=$((mt - ma))
  mem_p=$(( mu * 100 / mt ))
  # to GiB with one decimal
  printf -v mem_str "%.1f GiB / %.1f GiB (%d%%)" "$((mu/1024))e-3" "$((mt/1024))e-3" "$mem_p"

  # Swap
  local st su sp; st=$(awk '/SwapTotal:/ {print $2}' /proc/meminfo); su=$(awk '/SwapFree:/ {print $2}' /proc/meminfo)
  sp=0; ((st>0)) && sp=$(( (st - su) * 100 / st ))
  printf -v swap_str "%.1f GiB / %.1f GiB (%d%%)" "$(((st - su)/1024))e-3" "$((st/1024))e-3" "$sp"

  # Disk (root)
  local total used percent mount fs_type
  read -r total used percent mount <<<"$(df -BG / | awk 'NR==2{print $2,$3,$5,$6}')"
  fs_type="$(df -T / | awk 'NR==2{print $2}')"
  local disk="${used} / ${total} (${percent}) - ${fs_type}"

  # Locale
  local locale="$LANG"

  # Print
  printf "${C}OS:${R} %s\n" "$os"
  printf "${C}Host:${R} %s\n" "$host_model"
  printf "${C}Kernel:${R} %s\n" "$kernel"
  printf "${C}Uptime:${R} %s\n" "$uptime"
  printf "${C}Packages:${R} %s\n" "$pkg_count"
  printf "${C}Shell:${R} %s\n" "$shell"
  printf "${C}WM:${R} %s\n" "$desktop"
  printf "${C}CPU:${R} %s\n" "$cpu"
  printf "${C}GPU:${R} %s\n" "$gpu"
  printf "${C}Memory:${R} %s\n" "$mem_str"
  printf "${C}Swap:${R} %s\n" "$swap_str"
  printf "${C}Disk (%s):${R} %s\n" "${mount:-/}" "$disk"
  printf "${C}Locale:${R} %s\n" "$locale"
}
