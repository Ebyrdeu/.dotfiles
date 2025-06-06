SAVEIFS=$IFS
IFS=$' \t\n'

function ex {
    if [ $# -eq 0 ]; then
        cat <<EOF
Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>
       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]
EOF
        return 1
    fi

    set -e  # abort execution on errors

    if [ $# -eq 0 ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"

        return 1
    fi

    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar --auto-compress -xvf "$n" ;;
            *.lzma)      unlzma "$n" ;;
            *.bz2)       bunzip2 "$n" ;;
            *.cbr|*.rar) unrar x -ad "$n" ;;
            *.gz)        gunzip "$n" ;;
            *.cbz|*.epub|*.zip) unzip "$n" ;;
            *.z)         uncompress "$n" ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                         7z x "$n" ;;
            *.xz)        unxz "$n" ;;
            *.exe)       cabextract "$n" ;;
            *.cpio)      cpio -id < "$n" ;;
            *.cba|*.ace) unace x "$n" ;;
            *.zpaq)      zpaq x "$n" ;;
            *.arc)       arc e "$n" ;;
            *.cso)       ciso 0 "$n" "$n.iso" && extract "$n.iso" && rm -f "$n" ;;
            *.zlib)      zlib-flate -uncompress < "$n" > "${n%.*zlib}" && rm -f "$n" ;;
            *.dmg)
                         mnt_dir=$(mktemp -d)
                         hdiutil mount "$n" -mountpoint "$mnt_dir"
                         echo "Mounted at: $mnt_dir" ;;
            *.tar.zst)  tar -I zstd -xvf "$n" ;;
            *.zst)      zstd -d "$n" ;;
            *)
                echo "extract: '$n' - unknown archive method"
                continue ;;
        esac
    done
}

IFS=$SAVEIFS


function connect {
    # 1) Refresh the list of Wi-Fi networks to ensure we have up-to-date information.
    #    ‘nmcli device wifi rescan’ forces a new scan for wireless networks.
    echo "Rescanning for available Wi-Fi networks..."
    nmcli device wifi rescan >/dev/null 2>&1

    # 2) Retrieve and parse the list of available Wi-Fi networks.
    #    We use `nmcli --terse --fields SSID,SIGNAL device wifi list` to get:
    #      SSID   SIGNAL
    #    in a machine-parsable (colon-delimited) format. We will skip the header row.
    #
    #    Example raw output (fields separated by colons):
    #      SSID1:75
    #      SSID2:40
    #      SSID3:90
    #
    #    We then enumerate them (1, 2, 3 …), store them in arrays, and display them.
    mapfile -t raw_networks < <(nmcli --terse --fields SSID,SIGNAL device wifi list | tail -n +1)

    # If there are no networks in the list, inform the user and exit the function.
    if [ ${#raw_networks[@]} -eq 0 ]; then
        echo "No Wi-Fi networks detected. Please ensure your wireless interface is up."
        return 1
    fi

    # 3) Build two parallel arrays: one for SSID names, one for signal strengths.
    local ssid_list=()
    local strength_list=()

    for entry in "${raw_networks[@]}"; do
        # Each line is formatted as "SSID:SIGNAL"
        IFS=":" read -r ssid signal <<< "$entry"
        # Some SSIDs may be empty (hidden networks). Represent them as "<Hidden SSID>".
        if [ -z "$ssid" ]; then
            ssid="<Hidden SSID>"
        fi
        ssid_list+=("$ssid")
        strength_list+=("$signal")
    done

    # 4) Display the numbered list of available networks with their signal strengths.
    echo ""
    echo "Available Wi-Fi Networks:"
    echo "-------------------------"
    for index in "${!ssid_list[@]}"; do
        # index starts at 0; for display, add 1.
        printf "%3d) %-30s Signal: %3s%%\n" $((index + 1)) "${ssid_list[$index]}" "${strength_list[$index]}"
    done

    # 5) Prompt the user to choose a network by number.
    echo ""
    # Loop until valid input is provided.
    local chosen_index
    while true; do
        read -rp "Enter the number of the network you wish to connect to (or 'q' to quit): " choice
        # If the user types 'q' or 'Q', exit the function gracefully.
        if [[ "$choice" =~ ^[Qq]$ ]]; then
            echo "Operation cancelled by user."
            return 0
        fi
        # Check if the input is an integer within the valid range.
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#ssid_list[@]}" ]; then
            chosen_index=$((choice - 1))
            break
        else
            echo "Invalid selection. Please enter a number between 1 and ${#ssid_list[@]}, or 'q' to quit."
        fi
    done

    # 6) Extract the SSID corresponding to the chosen index.
    local target_ssid="${ssid_list[$chosen_index]}"
    echo ""
    echo "Attempting to connect to: '$target_ssid' ..."
    echo "------------------------------------------"

    # 7) Use nmcli to connect. If the SSID is password-protected, nmcli will prompt for a password.
    #
    #    We invoke:
    #      nmcli device wifi connect "<SSID>"
    #
    #    If you need to force a specific interface, append: `ifname "<interface>"`
    nmcli --ask device wifi connect "$target_ssid"
    local nmcli_status=$?

    # 8) Check the exit status of nmcli to see if the connection succeeded.
    if [ $nmcli_status -ne 0 ]; then
        echo ""
        echo "Error: Failed to connect to '$target_ssid'. Please verify the SSID and password, then try again."
        return $nmcli_status
    fi

    # 9) Once connected, query nmcli for the currently active Wi-Fi connection:
    #      nmcli --terse --fields ACTIVE,SSID device wifi
    #    This prints lines like:
    #      yes:MyHomeNetwork
    #      no:OtherNetwork
    #    We then isolate the line starting with 'yes' to identify the connected SSID.
    echo ""
    echo "Connection successful. Determining the currently connected network..."
    current_ssid=$(nmcli --terse --fields ACTIVE,SSID device wifi | grep '^yes:' | cut -d: -f2-)

    if [ -n "$current_ssid" ]; then
        echo "Currently connected to: '$current_ssid'"
    else
        echo "Warning: Could not detect an active connection, despite no apparent errors."
    fi

    return 0
}

function sysinfo {
    # Define color codes for labels (bright cyan) and reset
    local C="\e[1;36m"
    local R="\e[0m"

    # 1) OS and Architecture
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        os="${NAME} $(uname -m)"
    else
        os="$(uname -s) $(uname -m)"
    fi

    # 2) Host Information
    if [ -r /sys/class/dmi/id/product_name ] && [ -r /sys/class/dmi/id/product_version ]; then
        host_model="$(cat /sys/class/dmi/id/product_name) $(cat /sys/class/dmi/id/product_version)"
    else
        host_model="Unknown"
    fi

    # 3) Kernel Version
    kernel="Linux $(uname -r)"

    # 4) Uptime (formatted as "X hours, Y mins")
    uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
    hours=$((uptime_seconds / 3600))
    minutes=$(( (uptime_seconds % 3600) / 60 ))
    uptime=""
    [ $hours -gt 0 ] && uptime+="${hours} hour"
    [ $hours -gt 1 ] && uptime+="s"
    [ $hours -gt 0 ] && [ $minutes -gt 0 ] && uptime+=", "
    [ $minutes -gt 0 ] && uptime+="${minutes} min"
    [ $minutes -gt 1 ] && uptime+="s"

    # 5) Package Count
    if command -v pacman >/dev/null 2>&1; then
        pkg_count="$(pacman -Q 2>/dev/null | wc -l) (pacman)"
    else
        pkg_count="N/A"
    fi

    # 6) Shell Version
    if [ -n "$BASH_VERSION" ]; then
        shell="bash $BASH_VERSION"
    else
        shell="$(basename "$SHELL") $($SHELL --version 2>/dev/null | head -n1 | awk '{print $NF}' || echo "?")"
    fi

    # 7) Desktop Environment/WM
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        desktop="$XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        desktop="$DESKTOP_SESSION"
    else
        desktop="N/A"
    fi

    # 8) CPU Information
    cpu_model="$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo 2>/dev/null | sed 's/^ //')"
    cpu_cores=$(grep -c '^processor' /proc/cpuinfo)
    cpu_speed=$(awk -F: '/cpu MHz/ {speed=$2/1000; printf "%.2f", speed; exit}' /proc/cpuinfo 2>/dev/null)
    [ -z "$cpu_speed" ] && cpu_speed="N/A"
    cpu="${cpu_model} ($cpu_cores) @ ${cpu_speed} GHz"

    # 9) GPU Information
    gpu="$(lspci | grep -i 'vga\|3d\|display' | cut -d ':' -f3 | sed 's/^ //;s/(.*//' | head -n1)"
    [ -z "$gpu" ] && gpu="N/A"

    # 10) Memory Usage (GiB)
    mem_total=$(free -g | awk '/Mem:/ {print $2}')
    mem_used=$(free -g | awk '/Mem:/ {print $3}')
    mem_percent=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
    memory="${mem_used}.${mem_percent: -2} GiB / ${mem_total}.00 GiB ($mem_percent%)"

    # 11) Swap Usage (GiB)
    swap_total=$(free -g | awk '/Swap:/ {print $2}')
    swap_used=$(free -g | awk '/Swap:/ {print $3}')
    swap_percent=$(free | awk '/Swap:/ {printf "%.0f", ($2==0) ? 0 : $3/$2 * 100}')
    swap="${swap_used}.00 GiB / ${swap_total}.00 GiB ($swap_percent%)"

    # 12) Disk Usage (GiB)
    disk_info=$(df -BG / | awk 'NR==2 {print $2,$3,$5,$6}')
    read -r total used percent mount <<< "$disk_info"
    fs_type=$(df -T / | awk 'NR==2 {print $2}')
    disk="${used} / ${total} ($percent) - $fs_type"

    # 13) Locale
    locale="$LANG"

    # Print all collected fields in the exact format
    printf "${C}OS:${R} %s\n" "$os"
    printf "${C}Host:${R} %s\n" "$host_model"
    printf "${C}Kernel:${R} %s\n" "$kernel"
    printf "${C}Uptime:${R} %s\n" "$uptime"
    printf "${C}Packages:${R} %s\n" "$pkg_count"
    printf "${C}Shell:${R} %s\n" "$shell"
    printf "${C}WM:${R} %s\n" "$desktop"
    printf "${C}CPU:${R} %s\n" "$cpu"
    printf "${C}GPU:${R} %s\n" "$gpu"
    printf "${C}Memory:${R} %s\n" "$memory"
    printf "${C}Swap:${R} %s\n" "$swap"
    printf "${C}Disk (%s):${R} %s\n" "${mount:-/}" "$disk"
    printf "${C}Locale:${R} %s\n" "$locale"
}
