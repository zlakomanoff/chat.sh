#!/bin/bash

read message

if [[ "$message" = 'give_me_port' ]]
then
	count=`ls *.fifo | wc -l`
	port=$(($count+6201))
	#nc -l -p $port -e client_listener.sh &
	echo $port
else
	echo 'wrong_message'
fi
