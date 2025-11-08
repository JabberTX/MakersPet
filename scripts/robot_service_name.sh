#!/bin/bash

SERVICE_FILE="/etc/avahi/services/ros2-agent.service"
SERVICE_NAME="avahi-daemon"

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run with sudo."
    echo "Usage: sudo $0 ROBOT_NAME"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Error: You must provide a single argument for the Robots name."
    echo "Usage: sudo $0 ROBOT_NAME"
    exit 1
fi

ROBONAME="$1"

# Backup the existing service file if it exists
if [ -f "$SERVICE_FILE" ]; then
  cp "$SERVICE_FILE" "$SERVICE_FILE.backup"
  echo "Backup created, updated file being created"
else
  if dpkg -s avahi-daemon &> /dev/null; then
      echo "avahi-daemon service is already installed."
  else
      echo "avahi-daemon service not found. Installing..."
      if ! apt-get update; then
          echo "Error: Failed to update package list."
          exit 1
      fi
      if ! apt-get install avahi-daemon -y; then
          echo "Error: Failed to install avahi-daemon."
          exit 1
      fi
      echo "avahi-daemon service installation complete."
  fi
fi

echo "Creating service file: $SERVICE_FILE"
tee "$SERVICE_FILE" > /dev/null << EOF
<service-group>
  <name replace-wildcards="yes">%h ROS2 Agent</name>
  <service>
    <type>${ROBONAME}._udp</type>
    <port>8888</port>
  </service>
</service-group>
EOF

if [ $? -ne 0 ]; then
    echo "Error: Failed to create or rewrite the service file."
    exit 1
fi

echo "Successfully wrote content to $SERVICE_FILE with the Robot name: $ROBONAME"
echo "Restarting $SERVICE_NAME to load new configuration..."

systemctl restart "$SERVICE_NAME"

if [ $? -ne 0 ]; then
    echo "Error: Failed to restart $SERVICE_NAME."
    exit 1
fi

echo "Successfully restarted $SERVICE_NAME."
echo "Service update complete."