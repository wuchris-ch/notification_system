#!/bin/bash

# Easy cron job adder for family reminders
echo "=== Easy Cron Reminder Adder ==="
echo ""

# Get reminder details
read -p "What's the recurring reminder? (e.g., 'Take medicine'): " REMINDER
echo ""
echo "When should this repeat?"
echo "1. Daily at specific time"
echo "2. Weekly on specific day"
echo "3. Monthly on specific date"
echo "4. Every X hours"
echo "5. Every X minutes"
read -p "Choose option (1-5): " OPTION

case $OPTION in
    1)
        read -p "What time? (e.g., 9 for 9 AM, 14 for 2 PM): " HOUR
        CRON_JOB="0 $HOUR * * * /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\""
        ;;
    2)
        echo "0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday"
        read -p "Which day? (0-6): " DAY
        read -p "What time? (e.g., 8 for 8 AM): " HOUR
        CRON_JOB="0 $HOUR * * $DAY /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\""
        ;;
    3)
        read -p "Which date of month? (1-31): " DATE
        read -p "What time? (e.g., 9 for 9 AM): " HOUR
        CRON_JOB="0 $HOUR $DATE * * /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\""
        ;;
    4)
        read -p "Every how many hours? (e.g., 6 for every 6 hours): " HOURS
        CRON_JOB="0 */$HOURS * * * /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\""
        ;;
    5)
        read -p "Every how many minutes? (e.g., 30 for every 30 minutes): " MINUTES
        CRON_JOB="*/$MINUTES * * * * /Users/chris/NTFY\ Family/send_notification.sh \"$REMINDER\""
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "📅 Cron job to add:"
echo "$CRON_JOB"
echo ""
echo "To add this to your crontab:"
echo "1. Run: crontab -e"
echo "2. Add this line: $CRON_JOB"
echo "3. Save and exit (Ctrl+X, Y, Enter)"
echo ""
echo "💡 Or copy this command to add it automatically:"
echo "echo \"$CRON_JOB\" | crontab -" 