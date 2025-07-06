# Gmail API Email Notification Setup Guide

This guide will walk you through setting up email notifications using the official Gmail API, which is more reliable and secure than SMTP.

## Prerequisites

- Google account with Gmail
- Python 3.6 or higher
- Internet connection

## Step 1: Enable Gmail API and Get Credentials

### 1.1 Create a Google Cloud Project

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" → "New Project"
3. Enter project name: `NTFY-Family-Email`
4. Click "Create"

### 1.2 Enable Gmail API

1. In the Google Cloud Console, go to "APIs & Services" → "Library"
2. Search for "Gmail API"
3. Click on "Gmail API" and click "Enable"

### 1.3 Create Credentials

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. If prompted, configure the OAuth consent screen:
   - Choose "External" user type
   - Fill in required fields:
     - App name: `NTFY Family Notifications`
     - User support email: Your email
     - Developer contact: Your email
   - Click "Save and Continue" through all steps
4. Back to "Create OAuth client ID":
   - Application type: "Desktop application"
   - Name: `NTFY Family Email Client`
   - Click "Create"
5. Download the JSON file (rename it to `credentials.json`)

## Step 2: Install Required Python Libraries

```bash
pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

## Step 3: Create the Email Script

Create a new Python script that uses the Gmail API:

```python
#!/usr/bin/env python3

import os
import sys
import base64
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# Gmail API scope
SCOPES = ['https://www.googleapis.com/auth/gmail.send']

def authenticate_gmail():
    """Authenticate and return Gmail service object"""
    creds = None
    
    # Check if token.json exists (stores user's access and refresh tokens)
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    
    # If there are no (valid) credentials available, let the user log in
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not os.path.exists('credentials.json'):
                print("❌ Error: credentials.json not found!")
                print("Please download it from Google Cloud Console and place it in this directory.")
                return None
            
            flow = InstalledAppFlow.from_client_secrets_file('credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())
    
    return build('gmail', 'v1', credentials=creds)

def create_message(sender, to, subject, message_text):
    """Create a message for an email"""
    message = MIMEMultipart()
    message['to'] = to
    message['from'] = sender
    message['subject'] = subject
    
    message.attach(MIMEText(message_text, 'plain'))
    
    raw_message = base64.urlsafe_b64encode(message.as_bytes()).decode()
    return {'raw': raw_message}

def send_email_gmail_api(to_email, subject, message_text, from_email=None):
    """Send email using Gmail API"""
    try:
        # Authenticate
        service = authenticate_gmail()
        if not service:
            return False
        
        # Get user's email if not provided
        if not from_email:
            profile = service.users().getProfile(userId='me').execute()
            from_email = profile['emailAddress']
        
        # Create message
        message = create_message(from_email, to_email, subject, message_text)
        
        # Send message
        result = service.users().messages().send(userId='me', body=message).execute()
        
        print(f"✅ Email sent successfully to {to_email}")
        print(f"Message ID: {result['id']}")
        return True
        
    except Exception as e:
        print(f"❌ Error sending email: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 gmail_api_send.py recipient@email.com 'Subject' 'Message'")
        sys.exit(1)
    
    recipient = sys.argv[1]
    subject = sys.argv[2]
    message = sys.argv[3]
    
    send_email_gmail_api(recipient, subject, message)
```

## Step 4: Set Up Your Project Directory

1. Create a new directory for Gmail API setup:
```bash
mkdir gmail_api_setup
cd gmail_api_setup
```

2. Place your `credentials.json` file in this directory
3. Create the Python script above as `gmail_api_send.py`
4. Make it executable:
```bash
chmod +x gmail_api_send.py
```

## Step 5: First-Time Authentication

1. Run the script for the first time:
```bash
python3 gmail_api_send.py your-email@gmail.com "Test Subject" "Test message"
```

2. A browser window will open asking you to:
   - Sign in to your Google account
   - Grant permissions to the app
   - You'll see a warning about "unverified app" - click "Advanced" → "Go to NTFY Family Notifications (unsafe)"
   - Click "Allow" to grant Gmail sending permissions

3. The script will create a `token.json` file for future use

## Step 6: Test the Setup

```bash
python3 gmail_api_send.py recipient@example.com "NTFY Family Test" "This is a test email from the NTFY Family notification system!"
```

## Step 7: Integration with Your NTFY System

Create a wrapper script to integrate with your existing notification system:

```bash
#!/bin/bash
# gmail_notify.sh - Send both NTFY and Gmail notifications

RECIPIENT_EMAIL="family-member@gmail.com"
SUBJECT="$1"
MESSAGE="$2"

# Send NTFY notification (existing functionality)
./send_notification.sh "$SUBJECT" "$MESSAGE"

# Send Gmail notification
cd gmail_api_setup
python3 gmail_api_send.py "$RECIPIENT_EMAIL" "$SUBJECT" "$MESSAGE"
cd ..

echo "✅ Sent both NTFY and Gmail notifications"
```

## Step 8: Family Email List Setup

Create a script to send to multiple family members:

```python
#!/usr/bin/env python3
# family_gmail_notify.py

import sys
from gmail_api_send import send_email_gmail_api

# Add your family email addresses here
FAMILY_EMAILS = [
    "family-member1@gmail.com",
    "family-member2@gmail.com",
    "chriswu.ca@gmail.com"
]

def send_family_notification(subject, message):
    """Send email to all family members"""
    success_count = 0
    
    for email in FAMILY_EMAILS:
        print(f"Sending to {email}...")
        if send_email_gmail_api(email, subject, message):
            success_count += 1
    
    print(f"✅ Successfully sent to {success_count}/{len(FAMILY_EMAILS)} recipients")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 family_gmail_notify.py 'Subject' 'Message'")
        sys.exit(1)
    
    subject = sys.argv[1]
    message = sys.argv[2]
    
    send_family_notification(subject, message)
```

## Troubleshooting

### Common Issues:

1. **"credentials.json not found"**
   - Download the file from Google Cloud Console
   - Make sure it's in the same directory as your script

2. **"Access blocked: This app's request is invalid"**
   - Make sure you've enabled the Gmail API
   - Check that your OAuth consent screen is configured

3. **"insufficient authentication scopes"**
   - Delete `token.json` and re-authenticate
   - Make sure the SCOPES includes 'gmail.send'

4. **"The user has not granted the app"**
   - Go through the authentication flow again
   - Make sure to click "Allow" for all permissions

### Security Notes:

- Keep `credentials.json` and `token.json` secure
- Don't commit these files to version control
- The token will refresh automatically
- You only need to authenticate once per machine

## Alternative: App Passwords (Simpler but Less Secure)

If you prefer a simpler setup, you can use Gmail SMTP with app passwords:

1. Enable 2-factor authentication on your Gmail
2. Generate an app password: Google Account → Security → App passwords
3. Use the existing `send_email_python.py` script with your app password

## Recommendation

The Gmail API method is more secure and reliable than SMTP, but requires more initial setup. Choose based on your security requirements and technical comfort level.

For immediate family notifications, your existing NTFY system is excellent and doesn't require email setup unless you specifically need email delivery.