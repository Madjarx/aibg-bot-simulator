#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 0 ]; then
    echo "Usage: $0"
    exit 1
fi

# Load environment variables from the .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

# Check if required environment variables are set
if [ -z "$API_ENDPOINT" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Error: API_ENDPOINT, USERNAME, and PASSWORD must be set in the .env file."
    exit 1
fi

# Function to display colored text
color_echo() {
    local color="$1"
    local text="$2"
    echo -e "\e[${color}m${text}\e[0m"
}

# Loop to send POST requests with different usernames
for i in {1..4}; do
    CURRENT_USERNAME="${USERNAME}${i}"
    PAYLOAD="{\"username\":\"$CURRENT_USERNAME\",\"password\":\"$PASSWORD\"}"

    # Make the POST request using curl
    JWT_TOKEN=$(curl -s -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$API_ENDPOINT" | jq -r .jwtToken)

    # Display JWT token with colored output
    color_echo "32" "API bot${i} Jason Web Token:"
    color_echo "32" "$JWT_TOKEN"
    echo    # Add a new line for better readability
done
