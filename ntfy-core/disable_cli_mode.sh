#!/bin/bash

# Script to disable interactive CLI prompts for automated server use
echo "=== Disabling CLI Interactive Mode ==="

# Create non-interactive versions of scripts
echo "📝 Creating non-interactive script versions..."

# Create silent send_notification.sh
cat > send_notification_silent.sh << 'EOF'
#!/bin/bash
# Non-interactive notification sender
TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"
MESSAGE=${1:-"Automated notification"}
curl -s -d "$MESSAGE" "$SERVER/$TOPIC" > /dev/null 2>&1
EOF

# Create automated quick_reminder.sh
cat > quick_reminder_auto.sh << 'EOF'
#!/bin/bash
# Usage: ./quick_reminder_auto.sh "reminder text" "YYYY-MM-DD HH:MM" [minutes_before]
TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"

if [ $# -lt 2 ]; then
    echo "Usage: $0 'reminder text' 'YYYY-MM-DD HH:MM' [minutes_before]"
    echo "Example: $0 'Doctor appointment' '2025-07-15 14:30' 60"
    exit 1
fi

REMINDER="$1"
WHEN="$2"
MINUTES_BEFORE=${3:-30}

# Convert to timestamp
TARGET_TIMESTAMP=$(date -d "$WHEN" +%s 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Error: Invalid date format. Use YYYY-MM-DD HH:MM"
    exit 1
fi

REMINDER_TIMESTAMP=$((TARGET_TIMESTAMP - (MINUTES_BEFORE * 60)))
CURRENT_TIMESTAMP=$(date +%s)

if [ "$REMINDER_TIMESTAMP" -le "$CURRENT_TIMESTAMP" ]; then
    echo "Error: Reminder time is in the past"
    exit 1
fi

# Schedule with at
AT_TIME=$(date -d "@$REMINDER_TIMESTAMP" '+%H:%M %m/%d/%Y')
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "curl -s -d '⏰ REMINDER: $REMINDER' '$SERVER/$TOPIC'" | at "$AT_TIME" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Reminder scheduled: $REMINDER at $WHEN"
    # Silent confirmation
    curl -s -d "SCHEDULED: $REMINDER at $WHEN" "$SERVER/$TOPIC" > /dev/null 2>&1
else
    echo "Failed to schedule reminder"
    exit 1
fi
EOF

# Create automated cron adder
cat > add_cron_auto.sh << 'EOF'
#!/bin/bash
# Usage: ./add_cron_auto.sh "reminder text" "cron_schedule"
# Example: ./add_cron_auto.sh "Take medicine" "0 8 * * *"

if [ $# -ne 2 ]; then
    echo "Usage: $0 'reminder text' 'cron_schedule'"
    echo "Examples:"
    echo "  Daily 8 AM: $0 'Morning reminder' '0 8 * * *'"
    echo "  Weekly Mon 9 AM: $0 'Weekly task' '0 9 * * 1'"
    echo "  Monthly 1st 10 AM: $0 'Monthly task' '0 10 1 * *'"
    exit 1
fi

REMINDER="$1"
SCHEDULE="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CRON_JOB="$SCHEDULE $SCRIPT_DIR/send_notification_silent.sh \"$REMINDER\""

# Add to crontab
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

if [ $? -eq 0 ]; then
    echo "Cron job added: $REMINDER"
    echo "Schedule: $SCHEDULE"
else
    echo "Failed to add cron job"
    exit 1
fi
EOF

# Make all scripts executable
chmod +x send_notification_silent.sh
chmod +x quick_reminder_auto.sh
chmod +x add_cron_auto.sh

echo "✅ Non-interactive scripts created:"
echo "  📤 send_notification_silent.sh - Silent notifications"
echo "  ⏰ quick_reminder_auto.sh - Automated one-time reminders"
echo "  🔄 add_cron_auto.sh - Automated recurring reminders"
echo ""
echo "🔧 Usage examples:"
echo "  ./send_notification_silent.sh 'Dinner ready!'"
echo "  ./quick_reminder_auto.sh 'Doctor visit' '2025-07-15 14:30' 60"
echo "  ./add_cron_auto.sh 'Daily medicine' '0 8 * * *'"
echo ""
echo "💡 These scripts can be called from other programs or APIs without user interaction"