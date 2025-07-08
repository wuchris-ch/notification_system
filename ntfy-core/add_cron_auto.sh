#!/bin/bash

# Non-interactive version of add_cron_reminder.sh for web API
# Usage: ./add_cron_auto.sh "message" "cron_schedule"

# Check arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 \"message\" \"cron_schedule\""
    echo "Example: $0 \"Take medicine\" \"0 9 * * *\""
    exit 1
fi

REMINDER="$1"
CRON_SCHEDULE="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Build the full cron job command
CRON_JOB="$CRON_SCHEDULE $SCRIPT_DIR/send_notification.sh \"$REMINDER\""

# Add the cron job to the current user's crontab
# First, get existing crontab (if any)
TEMP_CRON=$(mktemp)
crontab -l 2>/dev/null > "$TEMP_CRON"

# Check if this exact job already exists
if grep -Fq "$CRON_JOB" "$TEMP_CRON" 2>/dev/null; then
    echo "Error: This cron job already exists" >&2
    rm -f "$TEMP_CRON"
    exit 1
fi

# Add the new job
echo "$CRON_JOB" >> "$TEMP_CRON"

# Install the updated crontab
if crontab "$TEMP_CRON" 2>/dev/null; then
    echo "Recurring reminder added successfully"
    echo "Schedule: $CRON_SCHEDULE"
    echo "Message: $REMINDER"
    
    # Send immediate confirmation
    TOPIC="family-alerts-tw-ca-bby"
    SERVER="https://ntfy.sh"
    curl -s -H "Title: Recurring Reminder Added" -d "RECURRING: $REMINDER (schedule: $CRON_SCHEDULE)" "$SERVER/$TOPIC" >/dev/null
    
    rm -f "$TEMP_CRON"
    exit 0
else
    echo "Error: Failed to add cron job" >&2
    rm -f "$TEMP_CRON"
    exit 1
fi