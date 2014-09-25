#!/bin/bash

if [ -z "$1" ]; then port=8000; else port=$1; fi
pipe='server.fifo' && rm -f *.fifo && mkfifo "$pipe"

coproc distributor { while true; do nc -l -p "$port" -e distributor.sh; done; }
echo "server started on $port"

while read data < "$pipe"; do
	pid=${data%%:*} && data=${data#$pid:}
	login=${data%%:*}
	message=${data#$login:}
	timestamp=$(date +%s)

	if [[ "$message" == 'exit' ]];
	then
		count=$(ls *.fifo | wc -l)
		if [[ "$count" -eq 1 ]];
		then
			kill -13 $distributor_PID
			wait $distributor_PID
			rm -f *.fifo
			echo 'server stoped'
			exit 0
		fi
	fi

	for pi in *.fifo
	do
		if [[ "$pi" != "$pipe" ]]; 
		then
			echo "$login:$timestamp:$message" > "$pi"
		fi
	done

done

