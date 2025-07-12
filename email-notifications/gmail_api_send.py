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

# Gmail API scope - only what we need
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
                print("See GMAIL_API_SETUP_GUIDE.md for detailed instructions.")
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
        
        # Use a default from email if not provided
        if not from_email:
            from_email = "me"  # Gmail API accepts "me" as the sender
        
        # Create message
        message = create_message(from_email, to_email, subject, message_text)
        
        # Send message
        result = service.users().messages().send(userId='me', body=message).execute()
        
        print(f"✅ Email sent successfully to {to_email}")
        print(f"📧 From: {from_email}")
        print(f"📋 Subject: {subject}")
        print(f"🆔 Message ID: {result['id']}")
        return True
        
    except Exception as e:
        print(f"❌ Error sending email: {e}")
        print("\n🔧 Troubleshooting:")
        print("1. Make sure credentials.json is in this directory")
        print("2. Check that Gmail API is enabled in Google Cloud Console")
        print("3. Verify you've completed the OAuth consent screen setup")
        print("4. See GMAIL_API_SETUP_GUIDE.md for detailed setup instructions")
        return False

def check_setup():
    """Check if the setup is complete"""
    if not os.path.exists('credentials.json'):
        print("❌ Setup incomplete: credentials.json not found")
        print("📖 Please follow the setup guide in GMAIL_API_SETUP_GUIDE.md")
        return False
    
    try:
        # Try to import required libraries
        import google.auth
        import googleapiclient
        print("✅ Required libraries are installed")
        return True
    except ImportError as e:
        print(f"❌ Missing required library: {e}")
        print("📦 Install with: pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Gmail API Email Sender")
        print("Usage: python3 gmail_api_send.py recipient@email.com 'Subject' 'Message'")
        print("")
        print("Setup status:")
        check_setup()
        sys.exit(1)
    
    recipient = sys.argv[1]
    subject = sys.argv[2]
    message = sys.argv[3]
    
    if check_setup():
        send_email_gmail_api(recipient, subject, message)
    else:
        print("\n📖 Please complete the setup first using GMAIL_API_SETUP_GUIDE.md")