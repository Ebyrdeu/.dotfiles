
#!/bin/bash

# Detect primary interface (default route)
primary_iface=$(ip route 2>/dev/null | awk '/^default /{print $5; exit}')

# Fallback: pick first non-loopback interface with an IPv4 address
if [[ -z "$primary_iface" ]]; then
    primary_iface=$(ip -o -4 addr show 2>/dev/null | awk '$2!="lo"{print $2; exit}')
fi

# If no interface found
if [[ -z "$primary_iface" ]]; then
    echo "No active network connection"
    exit 1
fi

# Detect type
if [[ -d "/sys/class/net/$primary_iface/wireless" ]]; then
    type="Wi-Fi"
elif [[ -r "/sys/class/net/$primary_iface/type" ]] && [[ $(cat /sys/class/net/$primary_iface/type) == "1" ]]; then
    type="Ethernet"
else
    type="Other"
fi

# Print in plain text (no background color)
echo "$type $primary_iface "
