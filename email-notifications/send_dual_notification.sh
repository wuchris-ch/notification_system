#!/bin/bash

# Dual Notification System - Send both NTFY and Gmail notifications
# Usage: ./send_dual_notification.sh "Subject" "Message"

SUBJECT="$1"
MESSAGE="$2"

# Check if arguments are provided
if [ -z "$SUBJECT" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 'Subject' 'Message'"
    echo ""
    echo "Examples:"
    echo "  $0 'Dinner Ready' 'Come to the kitchen!'"
    echo "  $0 'Meeting Tonight' 'Family meeting at 7 PM'"
    exit 1
fi

echo "🚀 Sending dual notifications..."
echo "📋 Subject: $SUBJECT"
echo "💬 Message: $MESSAGE"
echo "=" * 50

# Send NTFY notification (from ntfy-core directory)
echo "📱 Sending NTFY notification..."
if [ -f "../ntfy-core/send_notification.sh" ]; then
    ../ntfy-core/send_notification.sh "$SUBJECT" "$MESSAGE"
    NTFY_STATUS=$?
elif [ -f "./send_notification.sh" ]; then
    # Fallback for when running from server (deployed)
    ./send_notification.sh "$SUBJECT" "$MESSAGE"
    NTFY_STATUS=$?
else
    echo "⚠️  send_notification.sh not found - skipping NTFY"
    echo "💡 Make sure you're running from the project root or that scripts are deployed to server"
    NTFY_STATUS=1
fi

echo ""

# Send Gmail notification
echo "📧 Sending Gmail notifications..."
if [ -f "./family_gmail_notify.py" ]; then
    python3 family_gmail_notify.py "$SUBJECT" "$MESSAGE"
    GMAIL_STATUS=$?
else
    echo "⚠️  family_gmail_notify.py not found - skipping Gmail"
    GMAIL_STATUS=1
fi

echo ""
echo "=" * 50

# Summary
if [ $NTFY_STATUS -eq 0 ] && [ $GMAIL_STATUS -eq 0 ]; then
    echo "✅ Both NTFY and Gmail notifications sent successfully!"
elif [ $NTFY_STATUS -eq 0 ]; then
    echo "✅ NTFY notification sent successfully"
    echo "⚠️  Gmail notification failed"
elif [ $GMAIL_STATUS -eq 0 ]; then
    echo "⚠️  NTFY notification failed"
    echo "✅ Gmail notification sent successfully"
else
    echo "❌ Both notifications failed"
fi

echo ""
echo "💡 Tip: Use '../ntfy-core/send_notification.sh' for NTFY only or 'python3 family_gmail_notify.py' for Gmail only"