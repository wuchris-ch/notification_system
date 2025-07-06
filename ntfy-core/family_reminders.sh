#!/bin/bash

# Main family reminders menu
echo "=== Family Reminders Menu ==="
echo ""
echo "1. Send immediate notification (ntfy)"
echo "2. Add one-time reminder (ntfy)"
echo "3. Add recurring reminder (ntfy cron job)"
echo "4. Test notification (ntfy)"
echo "5. View current cron jobs"
echo "6. Exit"
echo ""
read -p "Choose option (1-6): " CHOICE

case $CHOICE in
    1)
        read -p "Enter your message: " MESSAGE
        ./send_notification.sh "$MESSAGE"
        ;;
    2)
        ./quick_reminder.sh
        ;;
    3)
        ./add_cron_reminder.sh
        ;;
    4)
        ./send_notification.sh "Test notification from family reminders menu! 🎉"
        ;;
    5)
        echo "Current cron jobs:"
        crontab -l 2>/dev/null || echo "No cron jobs found"
        ;;
    6)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac 