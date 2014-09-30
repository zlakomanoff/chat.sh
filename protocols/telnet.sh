#!/bin/bash
pipe="fifos/$$.fifo" && rm -f "$pipe" && mkfifo "$pipe"

# simple auth
echo 'Protocol: telnet'
echo 'Enter your nickname'

read login
echo "$$:$login:joined" > server.fifo

echo "$login: welcome to chat.sh"

# read server messages
while read server_data < "$pipe"; do
	nick=${server_data%%:*}
	if [[ "$nick" == "$login" ]]; then
		server_data="${server_data/$nick/me}"
	fi 
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
			echo "$$:$login:$user_message" > server.fifo
			exit 0
			;;
		*)
			echo "$$:$login:$user_message" > server.fifo
	esac
done
