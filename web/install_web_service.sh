#!/bin/bash

# Install Family Notifications as a systemd service
echo "🔧 Installing Family Notifications Web Service..."

# Create systemd service file
sudo tee /etc/systemd/system/family-notifications.service > /dev/null << EOF
[Unit]
Description=Family Notifications Web Server
After=network.target

[Service]
Type=simple
User=chris
WorkingDirectory=/home/chris/ntfy-family/web
ExecStart=/usr/bin/python3 /home/chris/ntfy-family/web/server.py 3000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable family-notifications.service

echo "✅ Service installed successfully!"
echo ""
echo "🎮 Service Commands:"
echo "  Start:   sudo systemctl start family-notifications"
echo "  Stop:    sudo systemctl stop family-notifications"
echo "  Status:  sudo systemctl status family-notifications"
echo "  Logs:    sudo journalctl -u family-notifications -f"
echo ""
echo "🚀 Starting service now..."
sudo systemctl start family-notifications

echo ""
echo "📱 Web interface available at:"
echo "  http://192.168.1.185:3000"
echo ""
echo "🔍 Check status:"
sudo systemctl status family-notifications --no-pager