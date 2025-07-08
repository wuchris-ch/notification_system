#!/bin/bash

# Non-interactive version of quick_reminder.sh for web API
# Usage: ./quick_reminder_auto.sh "message" "datetime" "minutes_before"

TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"

# Check arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 \"message\" \"datetime\" \"minutes_before\""
    echo "Example: $0 \"Bob dentist appointment\" \"2025-01-03 14:30\" \"30\""
    exit 1
fi

REMINDER="$1"
WHEN="$2"
MINUTES_BEFORE="$3"

# Function to parse date with year support
parse_date_with_year() {
    local input="$1"
    local current_year=$(date +%Y)
    
    # If no year is specified, try to parse and add current year
    if ! echo "$input" | grep -q '[0-9]\{4\}'; then
        # Try parsing without year first
        if date -j -f "%I:%M%p %b %d" "$input" "+%s" 2>/dev/null >/dev/null; then
            input="$input $current_year"
        elif date -j -f "%I:%M%p %b %d %Y" "$input $current_year" "+%s" 2>/dev/null >/dev/null; then
            input="$input $current_year"
        fi
    fi
    
    # Try various date formats with year support
    local formats=(
        "%Y-%m-%d %H:%M"       # 2026-01-03 14:30 (web format)
        "%I:%M%p %b %d %Y"     # 12:00pm Jan 3 2026
        "%H:%M %b %d %Y"       # 14:30 Jan 3 2026
        "%I:%M%p %B %d %Y"     # 12:00pm January 3 2026
        "%H:%M %B %d %Y"       # 14:30 January 3 2026
        "%b %d %Y %I:%M%p"     # Jan 3 2026 12:00pm
        "%B %d %Y %I:%M%p"     # January 3 2026 12:00pm
        "%m/%d/%Y %I:%M%p"     # 01/03/2026 12:00pm
    )
    
    for format in "${formats[@]}"; do
        if timestamp=$(date -j -f "$format" "$input" "+%s" 2>/dev/null); then
            echo "$timestamp"
            return 0
        fi
    done
    
    # Fallback: try system date parsing
    if timestamp=$(date -j -f "%c" "$input" "+%s" 2>/dev/null); then
        echo "$timestamp"
        return 0
    fi
    
    # Last resort: try GNU date style parsing (if available)
    if command -v gdate >/dev/null 2>&1; then
        if timestamp=$(gdate -d "$input" "+%s" 2>/dev/null); then
            echo "$timestamp"
            return 0
        fi
    fi
    
    return 1
}

# Parse the target time
TARGET_TIMESTAMP=$(parse_date_with_year "$WHEN")

if [ -z "$TARGET_TIMESTAMP" ]; then
    echo "Error: Could not parse the date '$WHEN'" >&2
    exit 1
fi

# Calculate reminder time (subtract minutes before)
REMINDER_TIMESTAMP=$((TARGET_TIMESTAMP - (MINUTES_BEFORE * 60)))
CURRENT_TIMESTAMP=$(date +%s)

# Check if reminder time is in the future
if [ "$REMINDER_TIMESTAMP" -le "$CURRENT_TIMESTAMP" ]; then
    echo "Error: Reminder time is in the past!" >&2
    echo "Target time: $(date -r "$TARGET_TIMESTAMP" '+%Y-%m-%d %I:%M%p')" >&2
    echo "Reminder time: $(date -r "$REMINDER_TIMESTAMP" '+%Y-%m-%d %I:%M%p')" >&2
    exit 1
fi

# Format dates for display
TARGET_DATE=$(date -r "$TARGET_TIMESTAMP" '+%Y-%m-%d %I:%M%p')
REMINDER_DATE=$(date -r "$REMINDER_TIMESTAMP" '+%Y-%m-%d %I:%M%p')

# Create the at job for the reminder
AT_TIME=$(date -r "$REMINDER_TIMESTAMP" '+%H:%M %m/%d/%Y')
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create temporary script for the at job
TEMP_SCRIPT=$(mktemp)
cat > "$TEMP_SCRIPT" << EOF
#!/bin/bash
cd "$SCRIPT_DIR"
./send_notification.sh "⏰ REMINDER: $REMINDER (scheduled for $TARGET_DATE)"
EOF
chmod +x "$TEMP_SCRIPT"

# Schedule the reminder using at
if command -v at >/dev/null 2>&1; then
    echo "bash $TEMP_SCRIPT" | at "$AT_TIME" 2>/dev/null
    if [ $? -eq 0 ]; then
        # Send immediate confirmation
        curl -s -H "Title: Reminder Scheduled" -d "SCHEDULED: $REMINDER at $TARGET_DATE (reminder will be sent $REMINDER_DATE)" "$SERVER/$TOPIC" >/dev/null
        
        echo "Reminder scheduled successfully"
        echo "Target time: $TARGET_DATE"
        echo "Reminder will be sent: $REMINDER_DATE"
        exit 0
    else
        echo "Failed to schedule with 'at' command" >&2
        exit 1
    fi
else
    echo "'at' command not available" >&2
    exit 1
fi

# Clean up temp script after a delay (in background)
(sleep 10 && rm -f "$TEMP_SCRIPT") &