# 🚀 Exact Deployment Steps

## Step 1: Deploy to Beelink Server

```bash
# Make scripts executable (already done)
chmod +x *.sh web/*.sh

# Deploy everything to server
./deploy_to_beelink.sh
```

## Step 2: Setup Server

```bash
# SSH to your beelink server
ssh -l chris 192.168.1.185

# Navigate to the deployed files
cd /home/chris/ntfy-family

# Run server setup (installs dependencies)
./server_setup.sh
```

## Step 3: Install Web Service

```bash
# Still on the server, go to web directory
cd web

# Install as systemd service (runs automatically)
./install_web_service.sh
```

## Step 4: Test Everything

```bash
# Test CLI notification
cd /home/chris/ntfy-family
./send_notification.sh "Test from server!"

# Check web service status
sudo systemctl status family-notifications

# Check if web server is running
curl http://localhost:3000/health
```

## Step 5: Access Web Interface

Open in any browser on your network:
**http://192.168.1.185:3000**

## 🔧 Troubleshooting

### If web service fails to start:
```bash
# Check logs
sudo journalctl -u family-notifications -f

# Restart service
sudo systemctl restart family-notifications

# Manual start (for testing)
cd /home/chris/ntfy-family/web
python3 server.py 3000
```

### If port 3000 is also in use:
```bash
# Check what's using the port
sudo netstat -tulpn | grep :3000

# Use different port
python3 server.py 3001
```

### If SSH connection fails:
```bash
# Test connection
ping 192.168.1.185

# Alternative access method you mentioned
simpleopen
```

## 📱 Family Setup

1. **Download ntfy app** on all family phones/tablets
2. **Subscribe to topic**: `family-alerts-tw-ca-bby`
3. **Bookmark web interface**: http://192.168.1.185:3000
4. **Test**: Send a notification via web interface

## ✅ Success Indicators

- ✅ Scripts deployed to `/home/chris/ntfy-family/`
- ✅ Web service running: `sudo systemctl status family-notifications`
- ✅ Web interface accessible: http://192.168.1.185:3000
- ✅ Test notification received on ntfy app
- ✅ Family can send notifications via web interface