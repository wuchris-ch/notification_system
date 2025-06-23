#!/bin/bash

# Family email sender with multiple recipients
# Edit the EMAIL_LIST below to add your family members

# Add your family email addresses here (separate with spaces)
EMAIL_LIST="chriswu.ca@gmail.com"

# Get message details
SUBJECT=${1:-"Family Notification"}
MESSAGE=${2:-"This is a family notification."}

# Send to all family members
for email in $EMAIL_LIST; do
    echo "Sending email to: $email"
    ./send_email_curl.sh "$email" "$SUBJECT" "$MESSAGE"
done

echo "✅ Email notifications sent to all family members!"
echo "Subject: $SUBJECT"
echo "Recipients: $EMAIL_LIST" 