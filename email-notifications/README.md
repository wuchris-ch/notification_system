# Email Notifications - Gmail API Integration

This directory contains Gmail API-based email notifications for additional delivery options alongside the core NTFY system.

## Quick Start

1. **Run setup script:**
   ```bash
   ./setup_gmail_notifications.sh
   ```

2. **Follow detailed setup guide:**
   See [`GMAIL_API_SETUP_GUIDE.md`](GMAIL_API_SETUP_GUIDE.md) for complete instructions

3. **Test your setup:**
   ```bash
   ./gmail_api_send.py your-email@gmail.com "Test" "Gmail API is working!"
   ```

## Email Scripts

- [`gmail_api_send.py`](gmail_api_send.py) - Single email sender using Gmail API
- [`family_gmail_notify.py`](family_gmail_notify.py) - Send emails to all family members
- [`send_dual_notification.sh`](send_dual_notification.sh) - Combined NTFY + Gmail notifications
- [`setup_gmail_notifications.sh`](setup_gmail_notifications.sh) - Automated setup script

## Documentation

- [`GMAIL_API_SETUP_GUIDE.md`](GMAIL_API_SETUP_GUIDE.md) - Complete Gmail API setup instructions
- [`GMAIL_QUICK_REFERENCE.md`](GMAIL_QUICK_REFERENCE.md) - Quick reference for email commands

## Usage Examples

### Single Email
```bash
./gmail_api_send.py recipient@email.com "Subject" "Message"
```

### Family Notifications
```bash
./family_gmail_notify.py "Subject" "Message"
```

### Dual Notifications (NTFY + Gmail)
```bash
./send_dual_notification.sh "Subject" "Message"
```

### Manage Family List
```bash
./family_gmail_notify.py --list                    # Show family members
./family_gmail_notify.py --add new@email.com       # Add family member
./family_gmail_notify.py --help                    # Show help
```

## Setup Requirements

### 1. Google Cloud Setup
- Create project at [Google Cloud Console](https://console.cloud.google.com/)
- Enable Gmail API
- Create OAuth credentials
- Download `credentials.json`

### 2. Python Dependencies
```bash
pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

### 3. First-Time Authentication
- Run any Gmail command
- Browser will open for Google login
- Grant permissions to your app
- `token.json` will be created automatically

## Integration with NTFY Core

Use [`send_dual_notification.sh`](send_dual_notification.sh) to send both NTFY push notifications and Gmail emails simultaneously:

```bash
./send_dual_notification.sh "Dinner Ready" "Come to the kitchen!"
```

This provides redundant delivery - family members get both push notifications and emails.

---

**Parent Project:** [NTFY Family](../README.md) | **Core System:** [NTFY Core](../ntfy-core/README.md)