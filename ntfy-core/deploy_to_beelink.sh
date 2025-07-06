#!/bin/bash

# Deploy NTFY Family system to beelink server
SERVER="192.168.1.185"
USER="chris"
REMOTE_DIR="/home/chris/ntfy-family"

echo "=== Deploying NTFY Family to Beelink Server ==="

# Create remote directories
ssh -l $USER $SERVER "mkdir -p $REMOTE_DIR $REMOTE_DIR/web"

# Copy all scripts
echo "📁 Copying scripts..."
scp *.sh $USER@$SERVER:$REMOTE_DIR/

# Copy README from parent directory
scp ../README.md $USER@$SERVER:$REMOTE_DIR/

# Copy web interface files
echo "🌐 Copying web interface..."
scp web/* $USER@$SERVER:$REMOTE_DIR/web/

# Make scripts executable on server
echo "🔧 Making scripts executable..."
ssh -l $USER $SERVER "chmod +x $REMOTE_DIR/*.sh $REMOTE_DIR/web/*.sh"

# Update paths in scripts for server environment
echo "🔧 Updating paths for server..."
ssh -l $USER $SERVER "
cd $REMOTE_DIR
# Update add_cron_reminder.sh to use correct paths
sed -i 's|/Users/chris/NTFY\\\\ Family/|$REMOTE_DIR/|g' add_cron_reminder.sh
sed -i 's|/Users/chris/NTFY Family/|$REMOTE_DIR/|g' add_cron_reminder.sh
"

echo "✅ Deployment complete!"
echo ""
echo "🔗 To access your server:"
echo "ssh -l chris 192.168.1.185"
echo ""
echo "📁 Files are in: $REMOTE_DIR"
echo "🚀 Test CLI: cd $REMOTE_DIR && ./send_notification.sh 'Hello from beelink!'"
echo "🌐 Setup web interface: cd $REMOTE_DIR/web && ./install_web_service.sh"
echo "📱 Web access: http://192.168.1.185:3000"