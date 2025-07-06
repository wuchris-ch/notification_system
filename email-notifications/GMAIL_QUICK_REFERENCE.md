# Gmail Notifications - Quick Reference

## 🚀 Quick Start

1. **Run the setup script:**
   ```bash
   ./setup_gmail_notifications.sh
   ```

2. **Follow the detailed guide:**
   - Open [`GMAIL_API_SETUP_GUIDE.md`](GMAIL_API_SETUP_GUIDE.md) for complete instructions

3. **Test your setup:**
   ```bash
   ./gmail_api_send.py your-email@gmail.com "Test" "Gmail API is working!"
   ```

## 📧 Available Commands

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

## 🔧 Setup Requirements

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

## 📁 File Structure

```
NTFY Family/
├── GMAIL_API_SETUP_GUIDE.md      # Complete setup instructions
├── GMAIL_QUICK_REFERENCE.md      # This file
├── setup_gmail_notifications.sh   # Automated setup script
├── gmail_api_send.py              # Single email sender
├── family_gmail_notify.py         # Family notification system
├── send_dual_notification.sh      # NTFY + Gmail combined
├── credentials.json               # Google API credentials (you create)
└── token.json                     # Auto-generated auth token
```

## 🔍 Troubleshooting

### Common Issues

**"credentials.json not found"**
- Download from Google Cloud Console
- Place in project directory

**"Access blocked: This app's request is invalid"**
- Enable Gmail API in Google Cloud Console
- Complete OAuth consent screen setup

**"insufficient authentication scopes"**
- Delete `token.json` and re-authenticate
- Make sure to grant all permissions

**Import errors**
- Run: `pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib`

### Getting Help

1. Check [`GMAIL_API_SETUP_GUIDE.md`](GMAIL_API_SETUP_GUIDE.md) for detailed instructions
2. Run `./setup_gmail_notifications.sh` for automated setup
3. Use `./family_gmail_notify.py --help` for command help

## 💡 Tips

- **Security**: Keep `credentials.json` and `token.json` private
- **Family List**: Edit [`family_gmail_notify.py`](family_gmail_notify.py) to add family emails
- **Integration**: Use [`send_dual_notification.sh`](send_dual_notification.sh) for both NTFY and Gmail
- **Testing**: Always test with your own email first

## 🎯 Examples

```bash
# Test single email
./gmail_api_send.py chriswu.ca@gmail.com "Test" "Hello from Gmail API!"

# Send family notification
./family_gmail_notify.py "Dinner Ready" "Come to the kitchen!"

# Send both NTFY and Gmail
./send_dual_notification.sh "Meeting Tonight" "Family meeting at 7 PM"

# Add family member
./family_gmail_notify.py --add newmember@gmail.com
```

---

**Next Steps:** Run `./setup_gmail_notifications.sh` to get started!