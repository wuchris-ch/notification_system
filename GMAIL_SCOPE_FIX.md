# Fix: "Request had insufficient authentication scopes"

## The Problem
You're getting Error 403: "insufficient authentication scopes" because the script was trying to access your Gmail profile, but we only granted permission to send emails.

## What I Fixed
1. **Removed profile access**: The script no longer tries to get your email address from your profile
2. **Simplified authentication**: Now uses only the "send email" permission
3. **Deleted old token**: Removed the old `token.json` that had incorrect permissions

## Next Steps

### Step 1: Test the Fixed Script
```bash
cd email-notifications
./gmail_api_send.py chriswu.ca@gmail.com "Test" "Fixed version test"
```

### Step 2: What Should Happen
1. **Browser opens**: You'll see the Google OAuth screen again
2. **Grant permission**: Click "Allow" for sending emails
3. **New token created**: A new `token.json` with correct permissions
4. **Email sent**: Should work without errors

### Step 3: If You Still Get "Access Blocked"
Make sure you've added yourself as a test user:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to "APIs & Services" → "OAuth consent screen"
3. Scroll to "Test users" section
4. Add your email: `chriswu.ca@gmail.com`
5. Click "SAVE"

## Technical Details

### What Changed in the Code:
```python
# OLD (caused the error):
profile = service.users().getProfile(userId='me').execute()
from_email = profile['emailAddress']

# NEW (works with send-only permission):
from_email = "me"  # Gmail API accepts "me" as sender
```

### Why This Works:
- Gmail API accepts `"me"` as the sender identifier
- No need to fetch your actual email address
- Only requires `gmail.send` scope (which you already granted)

## Testing Commands

After the fix, try these in order:

```bash
# 1. Basic test
./gmail_api_send.py chriswu.ca@gmail.com "Test 1" "Basic functionality test"

# 2. Family notification test
./family_gmail_notify.py "Test 2" "Family notification test"

# 3. Combined NTFY + Gmail test
./send_dual_notification.sh "Test 3" "Combined notification test"
```

## Expected Output
```
✅ Required libraries are installed
✅ Email sent successfully to chriswu.ca@gmail.com
📧 From: me
📋 Subject: Test 1
🆔 Message ID: 18c1234567890abcd
```

If you see this output, your Gmail API is working correctly!