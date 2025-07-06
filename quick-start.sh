#!/bin/bash

# NTFY Family - Quick Start Helper
# This script helps you navigate the reorganized project structure

echo "🏠 NTFY Family - Quick Start Helper"
echo "=================================="
echo ""

echo "📁 Project Structure:"
echo "  📂 ntfy-core/           - Basic NTFY notification system"
echo "  📂 email-notifications/ - Gmail API email notifications"
echo "  📄 README.md            - Main project documentation"
echo ""

echo "🚀 Quick Actions:"
echo ""

echo "1️⃣  Deploy NTFY Core System to Server:"
echo "   cd ntfy-core/ && ./deploy_to_beelink.sh"
echo ""

echo "2️⃣  Setup Email Notifications (Optional):"
echo "   cd email-notifications/ && ./setup_gmail_notifications.sh"
echo ""

echo "3️⃣  Send Test NTFY Notification:"
echo "   cd ntfy-core/ && ./send_notification.sh 'Test Message'"
echo ""

echo "4️⃣  Send Test Email Notification:"
echo "   cd email-notifications/ && ./gmail_api_send.py your-email@gmail.com 'Test' 'Message'"
echo ""

echo "5️⃣  Send Both NTFY + Email:"
echo "   cd email-notifications/ && ./send_dual_notification.sh 'Subject' 'Message'"
echo ""

echo "📖 Documentation:"
echo "   Main README:     README.md"
echo "   NTFY Core:       ntfy-core/README.md"
echo "   Email Setup:     email-notifications/README.md"
echo ""

echo "💡 Choose your path:"
echo "   [1] Basic NTFY only (recommended for most users)"
echo "   [2] NTFY + Email (for redundant delivery)"
echo ""

read -p "Enter choice (1 or 2), or press Enter to exit: " choice

case $choice in
    1)
        echo ""
        echo "🔔 Setting up NTFY Core System..."
        cd ntfy-core/
        echo "📁 Changed to ntfy-core/ directory"
        echo "🚀 Run: ./deploy_to_beelink.sh"
        ;;
    2)
        echo ""
        echo "📧 Setting up Email Notifications..."
        cd email-notifications/
        echo "📁 Changed to email-notifications/ directory"
        echo "🚀 Run: ./setup_gmail_notifications.sh"
        ;;
    *)
        echo ""
        echo "👋 Goodbye! Check README.md for detailed instructions."
        ;;
esac