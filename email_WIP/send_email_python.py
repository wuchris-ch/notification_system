#!/usr/bin/env python3

import smtplib
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(recipient, subject, message, sender_email=None, sender_password=None):
    """
    Send email using Gmail SMTP
    """
    # Default to Gmail settings
    smtp_server = "smtp.gmail.com"
    smtp_port = 587
    
    # If no sender credentials provided, use defaults (you'll need to set these)
    if not sender_email:
        sender_email = "your-email@gmail.com"  # Change this to your Gmail
    if not sender_password:
        sender_password = "your-app-password"   # Change this to your app password
    
    # Create message
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient
    msg['Subject'] = subject
    
    # Add body
    msg.attach(MIMEText(message, 'plain'))
    
    try:
        # Create server connection
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        
        # Login
        server.login(sender_email, sender_password)
        
        # Send email
        text = msg.as_string()
        server.sendmail(sender_email, recipient, text)
        server.quit()
        
        print(f"✅ Email sent successfully to {recipient}")
        return True
        
    except Exception as e:
        print(f"❌ Error sending email: {e}")
        print("\n📧 To fix this, you need to:")
        print("1. Enable 2-factor authentication on your Gmail")
        print("2. Generate an app password")
        print("3. Update the sender_email and sender_password in this script")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 send_email_python.py recipient@email.com 'Subject' 'Message'")
        sys.exit(1)
    
    recipient = sys.argv[1]
    subject = sys.argv[2]
    message = sys.argv[3]
    
    send_email(recipient, subject, message) 