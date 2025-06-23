#!/bin/bash

# Simple cron email sender using curl
# This can be used directly in cron jobs

RECIPIENT="chriswu.ca@gmail.com"
SUBJECT="Daily Family Reminder"
MESSAGE="Good morning! Don't forget to have a great day! 🌅"

# Option 1: Using a free email service API (like EmailJS)
# You'd need to sign up and get an API key
echo "📧 Cron job would send email to: $RECIPIENT"
echo "Subject: $SUBJECT"
echo "Message: $MESSAGE"

# Option 2: Using a webhook service (like IFTTT, Zapier)
# This is even simpler - just a webhook URL
echo ""
echo "💡 Even simpler: Use a webhook service like IFTTT or Zapier"
echo "   - Set up a webhook that sends emails"
echo "   - Cron job just calls the webhook URL"
echo "   - No API keys or complex setup needed"

# Option 3: Using a service like Mailgun with curl
# curl -X POST https://api.mailgun.net/v3/your-domain/messages \
#   -u "api:YOUR_API_KEY" \
#   -F from="Family Notifications <noreply@your-domain.com>" \
#   -F to="$RECIPIENT" \
#   -F subject="$SUBJECT" \
#   -F text="$MESSAGE" 