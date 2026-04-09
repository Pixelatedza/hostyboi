#!/bin/bash

## CONFIG
TOKEN=$(cat ~/.do_token)
DOMAIN="tisasillyplace.com"
RECORD_ID="1815275617" # The ID you found above
IP_FILE="current_ip.txt"

## GET CURRENT PUBLIC IP
CURRENT_IP=$(curl -s https://api.ipify.org)

# Check if we actually got an IP
if [[ ! $CURRENT_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Could not retrieve public IP."
    exit 1
fi

# GET PREVIOUS IP
[ -f "$IP_FILE" ] && OLD_IP=$(cat "$IP_FILE") || OLD_IP=""

# UPDATE IF CHANGED
if [ "$CURRENT_IP" != "$OLD_IP" ]; then
    echo "IP changed from $OLD_IP to $CURRENT_IP. Updating DigitalOcean..."

    RESPONSE=$(curl -s -X PUT -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"data\":\"$CURRENT_IP\"}" \
    "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$RECORD_ID")

    if echo "$RESPONSE" | grep -q "$CURRENT_IP"; then
        echo "$CURRENT_IP" > "$IP_FILE"
        echo "Successfully updated."
    else
        echo "Update failed. Response: $RESPONSE"
    fi
else
    echo "IP stable at $CURRENT_IP."
fi
