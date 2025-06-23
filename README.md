# Family Notification System

A simple family notification system using ntfy for real-time notifications and cron jobs for scheduled reminders.

## Features

- 📱 **Real-time notifications** via ntfy (works on all devices)
- ⏰ **Scheduled reminders** using cron jobs
- 👨‍👩‍👧‍👦 **Family-friendly** - easy to set up and use
- 🔒 **Private** - uses your own unique topic channel

## Quick Start

1. **Download ntfy app** on your phone and subscribe to your topic
2. **Test notification:**
   ```bash
   ./send_notification.sh "Hello family! 🎉"
   ```
3. **Set up reminders:**
   ```bash
   ./family_reminders.sh
   ```

## Scripts

### Main Scripts
- `family_reminders.sh` - Interactive menu for all functions
- `send_notification.sh` - Send immediate notifications
- `quick_reminder.sh` - Schedule one-time reminders
- `add_cron_reminder.sh` - Set up recurring reminders

### Usage Examples

```bash
# Send immediate notification
./send_notification.sh "Dinner's ready! 🍽️"

# Interactive menu
./family_reminders.sh

# Set up daily morning reminder
./add_cron_reminder.sh
# Choose: Daily at 7 AM with message "Good morning family!"
```

## Setup

1. **Configure your topic name** in `send_notification.sh`
2. **Install ntfy app** on family devices
3. **Subscribe to your topic** in the app
4. **Test the system** with a notification

## Cron Job Examples

```bash
# Daily morning reminder at 7:30 AM
30 7 * * * /path/to/send_notification.sh "Good morning family! 🌅"

# Weekly check-in (Sunday 2 PM)
0 14 * * 0 /path/to/send_notification.sh "Weekly family check-in!"

# Bedtime reminder (9:30 PM)
30 21 * * * /path/to/send_notification.sh "Bedtime reminder! 😴"
```

## Requirements

- macOS/Linux
- curl (built-in)
- cron (built-in)
- ntfy app on devices

## Email (Work in Progress)

Email functionality is in the `email_WIP/` folder for future development.

## Contributing

Feel free to fork and improve! This is a family project that grew into something useful.

## License

MIT License - Use it however you want!
