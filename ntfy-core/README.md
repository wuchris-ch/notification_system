# NTFY Core - Basic Notification System

This directory contains the core NTFY notification system for reliable push notifications to family devices.

## Quick Start

1. **Deploy to server:**
   ```bash
   ./deploy_to_beelink.sh
   ```

2. **SSH to server and setup:**
   ```bash
   ssh -l chris 192.168.1.185
   cd /home/chris/ntfy-family
   ./server_setup.sh
   ```

3. **Install web interface:**
   ```bash
   cd web
   ./install_web_service.sh
   ```

## Core Scripts

- [`send_notification.sh`](send_notification.sh) - Send immediate notifications
- [`quick_reminder.sh`](quick_reminder.sh) - Schedule one-time reminders  
- [`add_cron_reminder.sh`](add_cron_reminder.sh) - Set up recurring reminders
- [`family_reminders.sh`](family_reminders.sh) - Interactive menu for all functions
- [`server_setup.sh`](server_setup.sh) - Configure server dependencies
- [`deploy_to_beelink.sh`](deploy_to_beelink.sh) - Deploy system to server
- [`disable_cli_mode.sh`](disable_cli_mode.sh) - Create non-interactive versions

## Web Interface

- [`web/index.html`](web/index.html) - Responsive web interface
- [`web/server.py`](web/server.py) - Python web server with API
- [`web/start_web_server.sh`](web/start_web_server.sh) - Manual server startup
- [`web/install_web_service.sh`](web/install_web_service.sh) - Install as systemd service

## Documentation

- [`DEPLOYMENT_STEPS.md`](DEPLOYMENT_STEPS.md) - Step-by-step deployment guide
- [`server_usage_guide.md`](server_usage_guide.md) - Server usage instructions

## Usage

### Send Immediate Notification
```bash
./send_notification.sh "Dinner's ready! 🍽️"
```

### Schedule One-time Reminder
```bash
./quick_reminder.sh
```

### Set Up Recurring Reminder
```bash
./add_cron_reminder.sh
```

### Access Web Interface
Open http://192.168.1.185:3000 in any browser after deployment.

---

**Parent Project:** [NTFY Family](../README.md)