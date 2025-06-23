#!/usr/bin/env python3

import requests
import sys

def send_email_simple(recipient, subject, message):
    """
    Send email using a simple web service
    """
    # Using a free email service (you can replace with any service)
    # This is just an example - you'd need to sign up for a service
    
    print(f"📧 Sending email to: {recipient}")
    print(f"Subject: {subject}")
    print(f"Message: {message}")
    print("")
    
    # Example using a free email service (you'd need to sign up)
    # For now, this shows how it would work
    
    print("🔧 To make this work, you need to:")
    print("1. Sign up for a free email service like:")
    print("   - SendGrid (free tier: 100 emails/day)")
    print("   - Mailgun (free tier: 5,000 emails/month)")
    print("   - EmailJS (free tier: 200 emails/month)")
    print("2. Get an API key")
    print("3. Update this script with your API key")
    print("")
    print("💡 Or stick with ntfy - it's working perfectly!")
    
    return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 send_email_simple.py recipient@email.com 'Subject' 'Message'")
        sys.exit(1)
    
    recipient = sys.argv[1]
    subject = sys.argv[2]
    message = sys.argv[3]
    
    send_email_simple(recipient, subject, message) 