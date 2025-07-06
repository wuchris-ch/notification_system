# Using Your Beelink Server for NTFY Family

## Quick Deployment Steps

1. **Deploy from your local machine:**
   ```bash
   ./deploy_to_beelink.sh
   ```

2. **SSH into your server:**
   ```bash
   ssh -l chris 192.168.1.185
   # or just type: simpleopen
   ```

3. **Run setup on server:**
   ```bash
   cd /home/chris/ntfy-family
   ./server_setup.sh
   ```

4. **Test the system:**
   ```bash
   ./send_notification.sh "Hello from beelink! 🚀"
   ```

## Server Advantages

### Why Use Your Beelink Server:
- **Always On**: Server runs 24/7 for reliable scheduled reminders
- **Centralized**: All family notifications from one location
- **Low Power**: Beelink is energy efficient for continuous operation
- **Local Network**: Fast, reliable connection within your home

### Current Status Implementation:
- ✅ **CLI completed**: All scripts work and are ready to deploy
- 🔄 **Cronjob WIP**: [`add_cron_reminder.sh`](add_cron_reminder.sh:21) needs path updates for server
- 📱 **UI TODO**: Could add web interface later for family members

## Server Usage Patterns

### 1. Scheduled Reminders (Recommended)
```bash
# Set up daily medication reminder
./add_cron_reminder.sh
# Choose: Daily at 8 AM - "Take morning medication 💊"

# Set up weekly family meeting
./add_cron_reminder.sh  
# Choose: Weekly Sunday 2 PM - "Family meeting time! 👨‍👩‍👧‍👦"
```

### 2. One-time Reminders
```bash
# Quick appointment reminder
./quick_reminder.sh
# "Bob dentist appointment"
# "tomorrow 2pm"
# "30" minutes before
```

### 3. Immediate Notifications
```bash
# Dinner ready notification
./send_notification.sh "Dinner's ready! 🍽️"

# Emergency family alert
./send_notification.sh "🚨 URGENT: Please call home immediately"
```

## Disabling CLI After Completion

To make scripts non-interactive for automated use:

### Option 1: Environment Variables
```bash
# Set default values
export NTFY_TOPIC="family-alerts-tw-ca-bby"
export NTFY_SERVER="https://ntfy.sh"
export DEFAULT_REMINDER_MINUTES="30"
```

### Option 2: Command Line Arguments
```bash
# Modify scripts to accept all parameters as arguments
./quick_reminder.sh "Doctor appointment" "2025-07-15 14:30" "60"
```

### Option 3: Configuration File
Create `/home/chris/ntfy-family/config.conf`:
```bash
TOPIC="family-alerts-tw-ca-bby"
SERVER="https://ntfy.sh"
DEFAULT_MINUTES_BEFORE=30
SILENT_MODE=true
```

## Monitoring & Maintenance

### Check Running Jobs
```bash
# View scheduled at jobs
atq

# View cron jobs
crontab -l

# Check system logs
journalctl -u cron -f
```

### Server Health
```bash
# Check if server is reachable
ping 192.168.1.185

# Check ntfy connectivity
curl -d "Server health check" https://ntfy.sh/family-alerts-tw-ca-bby
```

## Next Steps for UI

If you want to add a web interface later:
1. Simple HTML form for family members
2. PHP/Python backend to call your scripts
3. Mobile-responsive design
4. Authentication for family members only

## Family Setup Checklist

- [ ] Deploy scripts to beelink server
- [ ] Install ntfy app on all family devices
- [ ] Subscribe everyone to `family-alerts-tw-ca-bby`
- [ ] Test with immediate notification
- [ ] Set up first recurring reminder
- [ ] Document family-specific reminders
- [ ] Train family members on emergency notifications