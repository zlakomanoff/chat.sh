#!/bin/bash

pipe="$$.fifo" && rm -f "$pipe" && mkfifo "$pipe"

echo "chat.sh: enter your nickname"
read name
echo "$$:$name:joined" > server.fifo

echo "chat.sh: $name welcome to chat.sh"

# read server messages
while read server_message < "$pipe"; do
	echo "$server_message";
done &

# read client messages
while read user_message; do 
	case "$user_message" in
		exit)
			kill -13 $!
			wait $!
			rm -f "$pipe"
			echo -e "game closed"
			echo "$$:$name:$user_message" > server.fifo
			exit 0
			;;
		*)
			echo "$$:$name:$user_message" > server.fifo
	esac
done

