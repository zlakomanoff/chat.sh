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
	if [ "${#server_message}" -gt 300 ]; then ${server_message:0:300}; fi

	if [[ "$server_message" =~ ^.+:.+:.+$ ]]; 
	then
		# user message
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
			time=$(date -d @$timestamp +"%T %z")

			echo -e "\e[32m$login \e[90m$time\e[0m"
			echo "${message}"
			echo 
		done

	else
		# system message
		echo "$server_message"
	fi

done


