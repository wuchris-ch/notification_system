#!/bin/bash

# Test IFTTT webhook
# Replace YOUR_WEBHOOK_URL with your actual webhook URL

WEBHOOK_URL="YOUR_WEBHOOK_URL"

echo "Testing IFTTT webhook..."
echo "Webhook URL: $WEBHOOK_URL"
echo ""

# Send test request
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{"value1":"Test from family notifications","value2":"This is working!","value3":"Great job!"}'

echo ""
echo "✅ Test sent! Check your email."
echo ""
echo "💡 To use this in cron jobs:"
echo "0 7 * * * curl -X POST \"$WEBHOOK_URL\" -H \"Content-Type: application/json\" -d '{\"value1\":\"Good morning family!\",\"value2\":\"Have a great day!\",\"value3\":\"🌅\"}'" 