#!/bin/bash

# Email sender using curl (alternative to mail command)
# This uses a free email service API

RECIPIENT=${1:-"test@example.com"}
SUBJECT=${2:-"Family Notification"}
MESSAGE=${3:-"This is a test email from your family notification system."}

# Using a free email service (you can replace with your preferred service)
# For now, let's use a simple approach with a web service

echo "📧 Attempting to send email to: $RECIPIENT"
echo "Subject: $SUBJECT"
echo "Message: $MESSAGE"
echo ""

# Note: This is a placeholder. For actual email sending, you have a few options:
# 1. Set up Gmail SMTP with app passwords
# 2. Use a service like SendGrid, Mailgun, etc.
# 3. Configure your Mac's mail settings properly

echo "⚠️  Email sending requires additional setup."
echo ""
echo "🔧 To fix this, you need to:"
echo "1. Configure your Mac's Mail app with your email account"
echo "2. Or use the Python script with Gmail SMTP"
echo "3. Or use a third-party email service"
echo ""
echo "💡 For now, the ntfy notifications are working perfectly!"
echo "   You can use those for immediate family communication." 