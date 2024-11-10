#!/bin/bash

# Initialize an empty variable to store the last clipboard content
last_clipboard=""

while true; do
    # Get the current clipboard content
    current_clipboard=$(pbpaste)

    # Check if the current clipboard content is different from the last one
    if [[ "$current_clipboard" != "$last_clipboard" ]]; then
        if [[ -n "$current_clipboard" ]]; then
            echo "Copying $current_clipboard"
	    printf "%s" "$current_clipboard" | ssh root@$public_ip 'cat > /var/www/html/c.txt'
        fi
        # Update last_clipboard with the new content
        last_clipboard="$current_clipboard"
    fi

    # Wait for a second before checking again
    sleep 1
done
