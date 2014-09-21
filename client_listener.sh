#!/bin/bash

echo 'welcome to durak.sh'
echo "your id: $$"
echo 
echo 'Please enter your name'
read name
echo "awaiting game start"

pipe="$$.fifo"
rm -f "$pipe"
mkfifo "$pipe"

# read game server messages
while read server_message < "$pipe"; do 
	case "$server_message" in
		exit)
			echo 'pipe listener exit'
			rm -f "$pipe"
			exit 0
			;;
		*)
			echo "$server_message to $name"
	esac
done &

# read client messages
while read user_message; do 
	case "$user_message" in
		exit)
			echo 'client exit'
			echo 'exit' > $pipe
			exit 0
			;;
		*)
			echo "$name: $user_message"
	esac
done

