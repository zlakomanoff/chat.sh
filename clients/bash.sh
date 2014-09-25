#!/bin/bash

echo 'connecting to server...'

attempts=0
coproc server { nc "$1" "$2"; }

while true; do
	echo 'gmport' >&${server[1]}
	read -ru ${server[0]} port
	if [[ "$port" =~ ^[0-9]{5}$ ]]
	then
		kill -13 "$server_PID"
		break
	else
		let "attempts++"
		if [ "$attempts" -eq 3 ];
		then
			echo 'can`t connect to server'
			exit 0
		else
			echo 'trying new attempt...'
		fi
	fi

done

sleep 1
nc "$1" "$port"
