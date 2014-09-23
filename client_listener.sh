#!/bin/bash

pipe="$$.fifo"
rm -f $pipe
mkfifo $pipe

echo -e "\\033c\e[34mdurak.sh\e[0m: please enter your name"
read name
echo "$$:$name:joined" > server.fifo

echo -e "\\033c\e[34mwelcome to durak.sh\e[0m"

# read server messages
while read server_message < $pipe; do 
	echo $server_message; 
done &

# read client messages
while read user_message; do 
	case "$user_message" in
		exit)
			kill $!
			wait $!
			rm -f $pipe 
			echo -e "\\033cgame closed"
			echo "$$:$name:$user_message" > server.fifo
			exit 0
			;;
		*)
			echo "$$:$name:$user_message" > server.fifo
	esac
done

