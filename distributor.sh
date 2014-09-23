#!/bin/bash

read message

if [[ "$message" == 'give_me_port' ]]
then
	while true; do
		port=50$(($RANDOM%10))$(($RANDOM%10))$(($RANDOM%10))
		usage=$(lsof -i :$port | wc -l)
		if [ $usage -eq 0 ]; then
			break
		fi
	done
	coproc $count { nc -l -p $port -e client_listener.sh; }
	echo $port
else
	echo 'wrong_message'
fi
