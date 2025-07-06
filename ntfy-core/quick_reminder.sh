#!/bin/bash

# Quick reminder adder for family notifications
TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"

echo "=== Quick Family Reminder Adder ==="
echo ""

# Get reminder details
read -p "What's the reminder? (e.g., 'Bob dentist appointment'): " REMINDER
read -p "When? (e.g., '3:30pm Jun 27 2025' or 'tomorrow 2pm' or '12:00pm Jan 3 2026'): " WHEN
read -p "How many minutes before to send? (default 30): " MINUTES_BEFORE
MINUTES_BEFORE=${MINUTES_BEFORE:-30}

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
        "%I:%M%p %b %d %Y"     # 12:00pm Jan 3 2026
        "%H:%M %b %d %Y"       # 14:30 Jan 3 2026
        "%I:%M%p %B %d %Y"     # 12:00pm January 3 2026
        "%H:%M %B %d %Y"       # 14:30 January 3 2026
        "%b %d %Y %I:%M%p"     # Jan 3 2026 12:00pm
        "%B %d %Y %I:%M%p"     # January 3 2026 12:00pm
        "%Y-%m-%d %H:%M"       # 2026-01-03 14:30
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
echo "Parsing date: $WHEN"
TARGET_TIMESTAMP=$(parse_date_with_year "$WHEN")

if [ -z "$TARGET_TIMESTAMP" ]; then
    echo "❌ Error: Could not parse the date '$WHEN'"
    echo "Please use formats like:"
    echo "  - '12:00pm Jan 3 2026'"
    echo "  - '2:30pm December 25 2025'"
    echo "  - '14:30 Jan 3 2026'"
    echo "  - '2026-01-03 14:30'"
    exit 1
fi

# Calculate reminder time (subtract minutes before)
REMINDER_TIMESTAMP=$((TARGET_TIMESTAMP - (MINUTES_BEFORE * 60)))
CURRENT_TIMESTAMP=$(date +%s)

# Check if reminder time is in the future
if [ "$REMINDER_TIMESTAMP" -le "$CURRENT_TIMESTAMP" ]; then
    echo "❌ Error: Reminder time is in the past!"
    echo "Target time: $(date -r "$TARGET_TIMESTAMP" '+%Y-%m-%d %I:%M%p')"
    echo "Reminder time: $(date -r "$REMINDER_TIMESTAMP" '+%Y-%m-%d %I:%M%p')"
    exit 1
fi

# Format dates for display
TARGET_DATE=$(date -r "$TARGET_TIMESTAMP" '+%Y-%m-%d %I:%M%p')
REMINDER_DATE=$(date -r "$REMINDER_TIMESTAMP" '+%Y-%m-%d %I:%M%p')

echo "Target time: $TARGET_DATE"
echo "Reminder will be sent: $REMINDER_DATE ($MINUTES_BEFORE minutes before)"

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
        echo "✅ Reminder scheduled using 'at' command"
        
        # Send immediate confirmation
        curl -H "Title: Reminder Scheduled" -d "SCHEDULED: $REMINDER at $TARGET_DATE (reminder will be sent $REMINDER_DATE)" "$SERVER/$TOPIC"
        
        echo ""
        echo "✅ Reminder scheduled: $REMINDER"
        echo "📅 Target time: $TARGET_DATE"
        echo "⏰ Reminder will be sent: $REMINDER_DATE"
        echo ""
        echo "📝 To view scheduled jobs: atq"
        echo "📝 To remove a job: atrm <job_number>"
    else
        echo "❌ Failed to schedule with 'at' command"
        echo "💡 You may need to enable the 'at' daemon or use cron instead"
    fi
else
    echo "❌ 'at' command not available"
    echo "💡 Install 'at' or use cron for scheduling"
fi

echo ""
echo "🔄 For recurring reminders, add to cron with:"
echo "crontab -e"
echo ""
echo "💡 Example cron entries:"
echo "# Daily at 9 AM: 0 9 * * * $SCRIPT_DIR/send_notification.sh \"$REMINDER\""
echo "# Weekly on Monday: 0 8 * * 1 $SCRIPT_DIR/send_notification.sh \"$REMINDER\""
echo "# Specific date: $(date -r "$REMINDER_TIMESTAMP" '+%M %H %d %m') * $SCRIPT_DIR/send_notification.sh \"$REMINDER\""

# Clean up temp script after a delay (in background)
(sleep 10 && rm -f "$TEMP_SCRIPT") &