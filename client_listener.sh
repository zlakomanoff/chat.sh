#!/bin/bash
pipe="fifos/$$.fifo" && rm -f "$pipe" && mkfifo "$pipe"
source "protocols/$1.sh";

# simple auth
echo "protocol: $1"
echo "enter your nickname"

read name
echo "$$:$name:joined" > server.fifo

echo "$name welcome to chat.sh"

# read server messages
while read server_data < "$pipe"; do
	output "$server_data"
done &

# read client messages
while read user_message; do
	case "$user_message" in
		'exit')
			/bin/kill -9 $!
			wait $! 2>/dev/null
			rm -f "$pipe"
			echo 'connection closed'
			echo "$$:$name:$user_message" > server.fifo
			exit 0
			;;
		*)
			input "$$:$name:$user_message" > server.fifo
	esac
done

