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
    nmcli device wifi connect "$target_ssid"
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

    # 1) Operating System and Version
    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        os="${NAME} ${VERSION_ID}"
    else
        os="$(uname -s) $(uname -r)"
    fi

    # 2) Kernel Version
    kernel="$(uname -r)"

    # 3) Uptime
    uptime="$(uptime -p | sed 's/up //')"

    # 4) Installed Package Count (including Flatpak)
    local pkg_str=""
    # Primary package manager
    if command -v dpkg-query >/dev/null 2>&1; then
        local dpkg_count
        dpkg_count="$(dpkg-query -f '${binary:Package}\n' -W 2>/dev/null | wc -l)"
        pkg_str="${dpkg_count} (dpkg)"
    elif command -v rpm >/dev/null 2>&1; then
        local rpm_count
        rpm_count="$(rpm -qa 2>/dev/null | wc -l)"
        pkg_str="${rpm_count} (rpm)"
    elif command -v pacman >/dev/null 2>&1; then
        local pacman_count
        pacman_count="$(pacman -Q 2>/dev/null | wc -l)"
        pkg_str="${pacman_count} (pacman)"
    else
        pkg_str="N/A"
    fi
    # Flatpak count
    if command -v flatpak >/dev/null 2>&1; then
        local flatpak_count
        flatpak_count="$(flatpak list --app 2>/dev/null | wc -l)"
        if [ "$pkg_str" != "N/A" ]; then
            pkg_str+=" + ${flatpak_count} (flatpak)"
        else
            pkg_str="${flatpak_count} (flatpak)"
        fi
    fi

    # 5) Default Shell
    shell="$(basename "$SHELL")"

    # 6) Desktop Environment or Window Manager
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        desktop="$XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        desktop="$DESKTOP_SESSION"
    else
        desktop="N/A"
    fi

    # 7) CPU Model
    cpu="$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo 2>/dev/null | sed 's/^ //')"
    [ -z "$cpu" ] && cpu="N/A"

    # 8) Memory Usage (SI units - GB)
    memory="$(free --si -h 2>/dev/null | awk '/Mem:/ {print $3 " / " $2}')"
    [ -z "$memory" ] && memory="N/A"

    # 9) Storage Info for Root Filesystem (SI units - GB)
    if df -H / >/dev/null 2>&1; then
        local df_output
        df_output="$(df -H / | awk 'NR==2 {print $2,$3,$4,$5}')"
        read -r total used free percent <<< "$df_output"
        storage="${used} used | ${free} free (${percent})"
    else
        storage="N/A"
    fi

    # 10) Swap Usage (SI units - GB)
    swap="$(free --si -h 2>/dev/null | awk '/Swap:/ {if ($2 == "0") print "0"; else print $3 "/" $2}')"
    [ -z "$swap" ] && swap="N/A"

    # 11) Print All Collected Fields with Colored Labels
    printf "${C}OS:${R}         %s\n" "$os"
    printf "${C}Kernel:${R}     %s\n" "$kernel"
    printf "${C}Uptime:${R}     %s\n" "$uptime"
    printf "${C}Packages:${R}   %s\n" "$pkg_str"
    printf "${C}Shell:${R}      %s\n" "$shell"
    printf "${C}DE/WM:${R}      %s\n" "$desktop"
    printf "${C}CPU:${R}        %s\n" "$cpu"
    printf "${C}Memory:${R}     %s\n" "$memory"
    printf "${C}Storage:${R}    %s\n" "$storage"
    printf "${C}Swap:${R}       %s\n" "$swap"
}
