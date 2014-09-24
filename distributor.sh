#!/bin/bash

echo 'chat.sh'
read message

if [[ "$message" == 'gmport' ]]
then

	while true; do
		port=50$(($RANDOM%10))$(($RANDOM%10))$(($RANDOM%10))
		usage=$(lsof -i :$port | wc -l)
		if [ "$usage" -eq 0 ]; then
			break
		fi
	done

	coproc nc -l -p "$port" -e client_listener.sh
	echo "$port"

else
	echo 'wrong_message'
fi
