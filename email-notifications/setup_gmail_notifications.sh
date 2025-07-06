#!/bin/bash

# Gmail Notification Setup Script
# This script helps you set up Gmail API notifications for your NTFY Family system

echo "📧 Gmail Notification Setup for NTFY Family"
echo "============================================"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "✅ Python 3 is installed: $(python3 --version)"

# Check if pip3 is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Please install pip3 first."
    exit 1
fi

echo "✅ pip3 is available"

# Install required Python packages
echo ""
echo "📦 Installing required Python packages..."
pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib

if [ $? -eq 0 ]; then
    echo "✅ Python packages installed successfully"
else
    echo "❌ Failed to install Python packages"
    exit 1
fi

# Check for credentials.json
echo ""
echo "🔑 Checking for Gmail API credentials..."
if [ -f "credentials.json" ]; then
    echo "✅ credentials.json found"
else
    echo "❌ credentials.json not found"
    echo ""
    echo "📋 Next steps:"
    echo "1. Follow the setup guide in GMAIL_API_SETUP_GUIDE.md"
    echo "2. Download credentials.json from Google Cloud Console"
    echo "3. Place it in this directory: $(pwd)"
    echo "4. Run this setup script again"
    echo ""
    echo "📖 Opening the setup guide..."
    if command -v open &> /dev/null; then
        open GMAIL_API_SETUP_GUIDE.md
    elif command -v xdg-open &> /dev/null; then
        xdg-open GMAIL_API_SETUP_GUIDE.md
    else
        echo "Please open GMAIL_API_SETUP_GUIDE.md manually"
    fi
    exit 1
fi

# Test the Gmail API setup
echo ""
echo "🧪 Testing Gmail API setup..."
python3 -c "
import sys
try:
    from gmail_api_send import check_setup
    if check_setup():
        print('✅ Gmail API setup is ready!')
        sys.exit(0)
    else:
        print('❌ Gmail API setup incomplete')
        sys.exit(1)
except Exception as e:
    print(f'❌ Error: {e}')
    sys.exit(1)
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Setup complete! You can now use Gmail notifications."
    echo ""
    echo "📋 Available commands:"
    echo "  ./gmail_api_send.py recipient@email.com 'Subject' 'Message'"
    echo "  ./family_gmail_notify.py 'Subject' 'Message'"
    echo "  ./send_dual_notification.sh 'Subject' 'Message'"
    echo ""
    echo "💡 Test with:"
    echo "  ./gmail_api_send.py your-email@gmail.com 'Test' 'Gmail API is working!'"
else
    echo ""
    echo "❌ Setup incomplete. Please check the error messages above."
    echo "📖 Refer to GMAIL_API_SETUP_GUIDE.md for detailed instructions."
fi