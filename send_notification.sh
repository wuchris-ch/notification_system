#!/bin/bash

# This script sends a notification to your ntfy topic
# Replace "YOUR_TOPIC_NAME" with your actual topic name

TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"

# Get the message from command line argument, or use default
MESSAGE=${1:-"Hello from your computer!"}

# Send the notification
curl -d "$MESSAGE" "$SERVER/$TOPIC"

echo "Notification sent to $TOPIC" 