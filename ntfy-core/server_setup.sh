#!/bin/bash

# Run this script ON the beelink server after deployment
echo "=== Setting up NTFY Family on Beelink Server ==="

# Install required packages (if needed)
echo "📦 Checking dependencies..."
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    sudo apt update && sudo apt install -y curl
fi

if ! command -v at &> /dev/null; then
    echo "Installing at daemon for scheduling..."
    sudo apt install -y at
    sudo systemctl enable atd
    sudo systemctl start atd
fi

# Set up cron if not already configured
echo "⏰ Setting up cron service..."
sudo systemctl enable cron
sudo systemctl start cron

# Create log directory
mkdir -p ~/logs

echo "✅ Server setup complete!"
echo ""
echo "🧪 Test your setup:"
echo "1. ./send_notification.sh 'Hello from beelink server!'"
echo "2. ./family_reminders.sh"
echo ""
echo "📱 Make sure ntfy app is subscribed to: family-alerts-tw-ca-bby"
echo "🔧 To disable CLI after completion, comment out the interactive parts"