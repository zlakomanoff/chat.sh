#!/bin/bash

while read message; do
	if [[ "$message" = 'give_me_port' ]]
	then
		count=`ls *.fifo | wc -l`
		count=$(($count+1))
		echo $count
	else
		echo 'wrong_message'
	fi
done
