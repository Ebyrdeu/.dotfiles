#!/bin/bash

# Get network interface, change 'wlp2s0' to your network interface name
INTERFACE="enp4s0"

# Get current speed using ifstat, -i specifies the interface, -q is quiet mode, -z is to skip zero stats
SPEED=$(ifstat -i $INTERFACE -q -z 1 1 | tail -n 1)

# Extract download and upload speeds
DOWNLOAD=$(echo $SPEED | awk '{print $1}')
UPLOAD=$(echo $SPEED | awk '{print $2}')

# Display the result in a format suitable for i3blocks
echo "D: $DOWNLOAD kB/s"

