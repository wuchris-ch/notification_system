#!/usr/bin/env python3

import sys
import os
from gmail_api_send import send_email_gmail_api, check_setup

# Add your family email addresses here
FAMILY_EMAILS = [
    "chriswu.ca@gmail.com",
    # "family-member2@gmail.com",
    # "family-member3@gmail.com"
]

def send_family_notification(subject, message):
    """Send email to all family members"""
    if not check_setup():
        print("❌ Gmail API not set up. Please run setup first.")
        return False
    
    success_count = 0
    total_count = len(FAMILY_EMAILS)
    
    print(f"📧 Sending family notification to {total_count} recipients...")
    print(f"📋 Subject: {subject}")
    print(f"💬 Message: {message}")
    print("-" * 50)
    
    for email in FAMILY_EMAILS:
        print(f"Sending to {email}...")
        if send_email_gmail_api(email, f"[NTFY Family] {subject}", message):
            success_count += 1
        print()
    
    print("-" * 50)
    print(f"✅ Successfully sent to {success_count}/{total_count} recipients")
    
    if success_count == total_count:
        print("🎉 All emails sent successfully!")
        return True
    elif success_count > 0:
        print("⚠️  Some emails failed to send")
        return False
    else:
        print("❌ All emails failed to send")
        return False

def add_family_member(email):
    """Add a new family member email to the list"""
    if email not in FAMILY_EMAILS:
        FAMILY_EMAILS.append(email)
        print(f"✅ Added {email} to family notification list")
        
        # Update the script file with the new email
        script_path = __file__
        with open(script_path, 'r') as f:
            content = f.read()
        
        # Find the FAMILY_EMAILS section and update it
        import re
        pattern = r'FAMILY_EMAILS = \[(.*?)\]'
        emails_str = ',\n    '.join([f'"{email}"' for email in FAMILY_EMAILS])
        new_content = re.sub(pattern, f'FAMILY_EMAILS = [\n    {emails_str}\n]', content, flags=re.DOTALL)
        
        with open(script_path, 'w') as f:
            f.write(new_content)
        
        print(f"📝 Updated {script_path} with new email list")
    else:
        print(f"ℹ️  {email} is already in the family notification list")

def list_family_members():
    """List all family members"""
    print("👨‍👩‍👧‍👦 Family notification list:")
    for i, email in enumerate(FAMILY_EMAILS, 1):
        print(f"  {i}. {email}")
    print(f"\nTotal: {len(FAMILY_EMAILS)} family members")

def show_help():
    """Show help information"""
    print("NTFY Family Gmail Notification System")
    print("=====================================")
    print()
    print("Usage:")
    print("  python3 family_gmail_notify.py 'Subject' 'Message'")
    print("  python3 family_gmail_notify.py --add email@example.com")
    print("  python3 family_gmail_notify.py --list")
    print("  python3 family_gmail_notify.py --help")
    print()
    print("Examples:")
    print("  python3 family_gmail_notify.py 'Dinner Ready' 'Come to the kitchen!'")
    print("  python3 family_gmail_notify.py 'Meeting Tonight' 'Family meeting at 7 PM'")
    print("  python3 family_gmail_notify.py --add newmember@gmail.com")
    print()
    print("Setup:")
    print("  1. Follow GMAIL_API_SETUP_GUIDE.md to configure Gmail API")
    print("  2. Edit this script to add your family email addresses")
    print("  3. Run a test notification")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        show_help()
        sys.exit(1)
    
    # Handle special commands
    if sys.argv[1] == "--help" or sys.argv[1] == "-h":
        show_help()
        sys.exit(0)
    elif sys.argv[1] == "--list" or sys.argv[1] == "-l":
        list_family_members()
        sys.exit(0)
    elif sys.argv[1] == "--add" or sys.argv[1] == "-a":
        if len(sys.argv) < 3:
            print("❌ Please provide an email address to add")
            print("Usage: python3 family_gmail_notify.py --add email@example.com")
            sys.exit(1)
        add_family_member(sys.argv[2])
        sys.exit(0)
    
    # Handle notification sending
    if len(sys.argv) < 3:
        print("❌ Please provide both subject and message")
        show_help()
        sys.exit(1)
    
    subject = sys.argv[1]
    message = sys.argv[2]
    
    send_family_notification(subject, message)