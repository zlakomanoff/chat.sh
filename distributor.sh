#!/bin/bash

read message

function get_port(){
	while true;
	do
		port=5$(($RANDOM%10))$(($RANDOM%10))$(($RANDOM%10))$(($RANDOM%10))
		usage=$(lsof -i :$port | wc -l)
		if [ "$usage" -eq 0 ]; 
		then
			break
		fi
	done
	echo "$port"
}

case "$message" in
	*)
		protocol='telnet'
		port=$(get_port)
		coproc nc -l -p "$port" -e "./client_listener.sh $protocol"
		echo "$port"
		;;
esac

