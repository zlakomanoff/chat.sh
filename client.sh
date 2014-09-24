#!/bin/bash

echo 'connecting to server...'

attempts=0
while true; do
	port=$(echo give_me_port | nc $1 $2)
	if [[ $port =~ ^[0-9]{5}$ ]]
	then
		break
	else
		echo $port
		let "attempts++"
		if [ $attempts -eq 3 ]; 
		then
			echo 'can`t connect to server'
			exit 0
		else
			echo 'trying new attempt...'
		fi
	fi
done

sleep 1
nc $1 $port
