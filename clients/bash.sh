#!/bin/bash

bufer=()
bufer_length=10
connection_attempts=3

coproc server { nc "$1" "$2" 2>/dev/null; }
attempts=0
echo 'connecting to server...'

while true; 
do

	if [ ! -z "${server[1]}" ];
	then
		echo 'gmport' >&${server[1]}
		read -ru ${server[0]} port
		if [[ "$port" =~ ^[0-9]{5}$ ]]
		then
			kill -13 "$server_PID"
			#wait "$server_PID" 2>/dev/null
			break
		else
			let "attempts++"
		fi
	else
		let "attempts++"
	fi

	if [ "$attempts" -eq "$connection_attempts" ];
	then
		echo 'can`t connect to server'
		exit 0
	else
		echo 'trying new attempt...'
		sleep 3
	fi

done

# waiting server
echo 'waiting server response'
sleep 1

nc "$1" "$port" | while read server_message; 
do
	echo -en "\\033c"

	bufer=("${bufer[@]}" "$server_message")
	length="${#bufer[@]}"

	if [ "$length" -gt "$bufer_length" ];
	then
		bufer=("${bufer[@]:1}")
	fi

	for data in "${bufer[@]}"
	do
		login=${data%%:*} && data=${data#$login:}
		timestamp=${data%%:*}
		message=${data#$timestamp:}

		echo "$login> ${message}"
	done

done


