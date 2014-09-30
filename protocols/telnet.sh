#!/bin/bash
pipe="fifos/$$.fifo" && rm -f "$pipe" && mkfifo "$pipe"

# simple auth
echo 'Protocol: telnet'
echo 'Enter your nickname'

read name
echo "$$:$name:joined" > server.fifo

echo "$name welcome to chat.sh"

# read server messages
while read server_data < "$pipe"; do
	echo "$server_data"
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
			echo "$$:$name:$user_message" > server.fifo
	esac
done
