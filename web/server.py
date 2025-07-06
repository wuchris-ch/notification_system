#!/usr/bin/env python3
"""
Simple web server for Family Notifications
Runs on Beelink server to provide web interface for ntfy notifications
"""

import os
import json
import subprocess
import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import threading

class NotificationHandler(BaseHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        self.script_dir = "/home/chris/ntfy-family"
        super().__init__(*args, **kwargs)
    
    def do_GET(self):
        """Handle GET requests"""
        parsed_path = urlparse(self.path)
        
        if parsed_path.path == '/' or parsed_path.path == '/index.html':
            self.serve_file('index.html', 'text/html')
        elif parsed_path.path == '/health':
            self.send_json_response({'status': 'ok', 'server': 'beelink'})
        else:
            self.send_error(404, "File not found")
    
    def do_POST(self):
        """Handle POST requests"""
        parsed_path = urlparse(self.path)
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        
        try:
            data = json.loads(post_data.decode('utf-8'))
        except json.JSONDecodeError:
            self.send_error(400, "Invalid JSON")
            return
        
        if parsed_path.path == '/api/send-notification':
            self.handle_send_notification(data)
        elif parsed_path.path == '/api/schedule-reminder':
            self.handle_schedule_reminder(data)
        elif parsed_path.path == '/api/add-recurring':
            self.handle_add_recurring(data)
        else:
            self.send_error(404, "API endpoint not found")
    
    def handle_send_notification(self, data):
        """Send immediate notification"""
        message = data.get('message', '')
        if not message:
            self.send_error(400, "Message is required")
            return
        
        try:
            # Call the send_notification.sh script
            result = subprocess.run([
                f"{self.script_dir}/send_notification.sh",
                message
            ], capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                self.send_json_response({
                    'success': True,
                    'message': 'Notification sent successfully'
                })
            else:
                self.send_error(500, f"Script failed: {result.stderr}")
        
        except subprocess.TimeoutExpired:
            self.send_error(500, "Request timeout")
        except Exception as e:
            self.send_error(500, f"Error: {str(e)}")
    
    def handle_schedule_reminder(self, data):
        """Schedule a one-time reminder"""
        message = data.get('message', '')
        date = data.get('date', '')
        time = data.get('time', '')
        minutes_before = data.get('minutesBefore', '30')
        
        if not all([message, date, time]):
            self.send_error(400, "Message, date, and time are required")
            return
        
        try:
            # Format datetime for the script
            datetime_str = f"{date} {time}"
            
            # Call the quick_reminder_auto.sh script (non-interactive version)
            result = subprocess.run([
                f"{self.script_dir}/quick_reminder_auto.sh",
                message,
                datetime_str,
                minutes_before
            ], capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                self.send_json_response({
                    'success': True,
                    'message': 'Reminder scheduled successfully'
                })
            else:
                self.send_error(500, f"Script failed: {result.stderr}")
        
        except Exception as e:
            self.send_error(500, f"Error: {str(e)}")
    
    def handle_add_recurring(self, data):
        """Add recurring reminder via cron"""
        message = data.get('message', '')
        freq_type = data.get('type', 'daily')
        time = data.get('time', '')
        day = data.get('day', '1')
        date = data.get('date', '1')
        
        if not all([message, time]):
            self.send_error(400, "Message and time are required")
            return
        
        try:
            # Parse time
            hour, minute = time.split(':')
            
            # Build cron schedule based on frequency type
            if freq_type == 'daily':
                cron_schedule = f"{minute} {hour} * * *"
            elif freq_type == 'weekly':
                cron_schedule = f"{minute} {hour} * * {day}"
            elif freq_type == 'monthly':
                cron_schedule = f"{minute} {hour} {date} * *"
            else:
                self.send_error(400, "Invalid frequency type")
                return
            
            # Call the add_cron_auto.sh script
            result = subprocess.run([
                f"{self.script_dir}/add_cron_auto.sh",
                message,
                cron_schedule
            ], capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                self.send_json_response({
                    'success': True,
                    'message': 'Recurring reminder added successfully',
                    'schedule': cron_schedule
                })
            else:
                self.send_error(500, f"Script failed: {result.stderr}")
        
        except Exception as e:
            self.send_error(500, f"Error: {str(e)}")
    
    def serve_file(self, filename, content_type):
        """Serve static files"""
        try:
            file_path = os.path.join(os.path.dirname(__file__), filename)
            with open(file_path, 'rb') as f:
                content = f.read()
            
            self.send_response(200)
            self.send_header('Content-Type', content_type)
            self.send_header('Content-Length', len(content))
            self.end_headers()
            self.wfile.write(content)
        
        except FileNotFoundError:
            self.send_error(404, "File not found")
        except Exception as e:
            self.send_error(500, f"Error serving file: {str(e)}")
    
    def send_json_response(self, data):
        """Send JSON response"""
        response = json.dumps(data).encode('utf-8')
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(response))
        self.end_headers()
        self.wfile.write(response)
    
    def log_message(self, format, *args):
        """Custom log format"""
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print(f"[{timestamp}] {format % args}")

def run_server(port=3000):
    """Run the web server"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, NotificationHandler)
    
    print(f"🌐 Family Notifications Web Server")
    print(f"📡 Server running on: http://192.168.1.185:{port}")
    print(f"🏠 Local access: http://localhost:{port}")
    print(f"📱 Family access: http://192.168.1.185:{port}")
    print(f"⏹️  Press Ctrl+C to stop")
    print()
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
        httpd.server_close()

if __name__ == '__main__':
    import sys
    
    port = 3000
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print("Invalid port number, using default 3000")
    
    run_server(port)