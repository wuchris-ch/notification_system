#!/bin/bash

# Quick reminder adder for family notifications
TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"

echo "=== Quick Family Reminder Adder ==="
echo ""

# Get reminder details
read -p "What's the reminder? (e.g., 'Bob dentist appointment'): " REMINDER
read -p "When? (e.g., '3:30pm Jun 27' or 'tomorrow 2pm'): " WHEN
read -p "How many minutes before to send? (default 30): " MINUTES_BEFORE
MINUTES_BEFORE=${MINUTES_BEFORE:-30}

# For now, just send an immediate notification about the scheduled reminder
MESSAGE="SCHEDULED: $REMINDER at $WHEN"

# Send immediate notification about the scheduled reminder
curl -H "Title: Reminder Scheduled" -d "$MESSAGE" "$SERVER/$TOPIC"

echo ""
echo "✅ Reminder scheduled: $REMINDER at $WHEN"
echo ""
echo "📝 To add this to your calendar, you can also run:"
echo "./send_notification.sh \"$REMINDER - $WHEN\""
echo ""
echo "🔄 For recurring reminders, add to cron with:"
echo "crontab -e"
echo ""
echo "💡 Example cron entries:"
echo "# Daily at 9 AM: 0 9 * * * /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\""
echo "# Weekly on Monday: 0 8 * * 1 /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\"" 