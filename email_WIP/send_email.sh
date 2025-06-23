#!/bin/bash

# Email sender script for family notifications
# Usage: ./send_email.sh "recipient@example.com" "Subject" "Message body"

RECIPIENT=${1:-"test@example.com"}
SUBJECT=${2:-"Family Notification"}
MESSAGE=${3:-"This is a test email from your family notification system."}

# Use the curl-based email sender
./send_email_curl.sh "$RECIPIENT" "$SUBJECT" "$MESSAGE"

echo "Email sent to $RECIPIENT"
echo "Subject: $SUBJECT"
echo "Message: $MESSAGE" 