#!/usr/bin/env python3

import requests
import sys
import json

def send_email_emailjs(recipient, subject, message):
    """
    Send email using EmailJS free service
    """
    # EmailJS configuration (you need to sign up at emailjs.com)
    # This is a template - you'll need to replace with your actual service ID and template ID
    
    service_id = "YOUR_SERVICE_ID"  # Replace with your EmailJS service ID
    template_id = "YOUR_TEMPLATE_ID"  # Replace with your EmailJS template ID
    user_id = "YOUR_USER_ID"  # Replace with your EmailJS user ID
    
    url = f"https://api.emailjs.com/api/v1.0/email/send"
    
    data = {
        "service_id": service_id,
        "template_id": template_id,
        "user_id": user_id,
        "template_params": {
            "to_email": recipient,
            "subject": subject,
            "message": message
        }
    }
    
    try:
        response = requests.post(url, json=data)
        if response.status_code == 200:
            print(f"✅ Email sent successfully to {recipient}")
            return True
        else:
            print(f"❌ Failed to send email: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def setup_instructions():
    """
    Show setup instructions for EmailJS
    """
    print("📧 EmailJS Setup Instructions:")
    print("")
    print("1. Go to https://www.emailjs.com/ and sign up (free)")
    print("2. Create an Email Service (Gmail, Outlook, etc.)")
    print("3. Create an Email Template")
    print("4. Get your Service ID, Template ID, and User ID")
    print("5. Update this script with your IDs")
    print("")
    print("💡 Or use ntfy - it's already working perfectly!")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 send_email_working.py recipient@email.com 'Subject' 'Message'")
        setup_instructions()
        sys.exit(1)
    
    recipient = sys.argv[1]
    subject = sys.argv[2]
    message = sys.argv[3]
    
    # Check if configured
    if "YOUR_SERVICE_ID" in open(__file__).read():
        print("📧 Email system not configured yet.")
        setup_instructions()
    else:
        send_email_emailjs(recipient, subject, message) 