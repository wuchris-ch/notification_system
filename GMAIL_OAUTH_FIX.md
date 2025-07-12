# Fix: "Access blocked: notification-system-gmail has not completed the Google verification process"

## The Problem
You're getting Error 403: access_denied because your OAuth app is in "testing" mode and you haven't added yourself as a test user.

## Quick Fix (5 minutes)

### Step 1: Go to Google Cloud Console
1. Open [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project (the one you created for Gmail API)

### Step 2: Configure OAuth Consent Screen
1. Go to "APIs & Services" → "OAuth consent screen"
2. You should see your app "NTFY Family Notifications" or similar

### Step 3: Add Test Users
1. Scroll down to the "Test users" section
2. Click "ADD USERS"
3. Add your email: `chriswu.ca@gmail.com`
4. Click "SAVE"

### Step 4: Test Again
Now try running your Gmail script again:
```bash
cd email-notifications
./gmail_api_send.py chriswu.ca@gmail.com "Test" "This should work now"
```

## Alternative: Publish the App (Optional)

If you want to skip the test user restriction entirely:

### Option A: Internal App (Recommended for personal use)
1. In OAuth consent screen, change "User Type" from "External" to "Internal"
2. This only works if you have a Google Workspace account

### Option B: Publish to Production (Not recommended for personal use)
1. In OAuth consent screen, click "PUBLISH APP"
2. This requires Google verification process (takes weeks)

## Why This Happens

Google OAuth apps start in "testing" mode for security. In testing mode:
- ✅ Only the app creator can use it
- ✅ Only explicitly added "test users" can use it
- ❌ Random people cannot access your app

This is actually good security - it prevents unauthorized access to your Gmail API.

## Current Status Check

After adding yourself as a test user, you should see:
- ✅ OAuth consent screen configured
- ✅ Your email in "Test users" list
- ✅ App status: "Testing" (this is fine for personal use)

## Next Steps

1. Add yourself as test user (steps above)
2. Test the Gmail API again
3. If it works, you can add other family members as test users too
4. Keep the app in "testing" mode for personal/family use

The "testing" mode is perfect for family notifications - you don't need to publish the app publicly.