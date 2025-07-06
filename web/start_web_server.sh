#!/bin/bash

# Start the Family Notifications Web Server on Beelink
echo "🌐 Starting Family Notifications Web Server..."

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Installing..."
    sudo apt update && sudo apt install -y python3
fi

# Set the correct script directory
SCRIPT_DIR="/home/chris/ntfy-family"
WEB_DIR="$SCRIPT_DIR/web"

# Make sure we're in the right directory
cd "$WEB_DIR"

# Update the server.py script directory if needed
sed -i "s|self.script_dir = \".*\"|self.script_dir = \"$SCRIPT_DIR\"|g" server.py

# Start the server
echo "🚀 Starting web server on port 3000..."
echo "📱 Family can access at: http://192.168.1.185:3000"
echo "💻 Local access at: http://localhost:3000"
echo ""
echo "⏹️  Press Ctrl+C to stop the server"
echo ""

python3 server.py 3000