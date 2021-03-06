#!/bin/bash

if [ -z "$1" ]; then port=8000; else port=$1; fi
pipe='server.fifo' && rm -f "$pipe" && mkfifo "$pipe"

function server_stop() {
	. killtree.sh
	echo 'waiting child processes'
	killtree $$ 15
	wait $$ 2>/dev/null
	rm -f "$pipe" && echo 'bye'
}
trap "server_stop; exit" SIGINT

{
	echo "server started on $port"
	while true; 
	do 
		nc -l -p "$port" -e './distributor.sh'
	done
} &

{
	echo 'woodpecker started'
	while true; 
	do
		for pi in fifos/*.fifo
   	do
      	if [[ "$pi" != 'fifos/*.fifo' ]];
      	then
				sleep 1
      		#timeout 0.1s echo "ping" > "$pi"
      	fi
   	done
		sleep 10
	done
} &

sleep 1
echo 'waiting incoming messages...'

while read data < "$pipe"; do
	
	pid=${data%%:*} && data=${data#$pid:}
	login=${data%%:*}
	message=${data#$login:}
	timestamp=$(date +%s)

	date2=$(date -d @$timestamp)
	echo "\"$date2\" \"$data\"" >> server.log

    for pi in fifos/*.fifo
    do
        if [[ "$pi" != 'fifos/*.fifo' ]];
        then
            echo "$login:$timestamp:$message" > "$pi"
        fi
    done

done

