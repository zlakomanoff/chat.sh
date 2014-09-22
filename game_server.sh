#!/bin/bash

pipe='server.fifo'
rm -f $pipe
mkfifo $pipe

while true; do
	nc -lk -p $1 -e distributor.sh
done &

echo "server started on $1"

while read data < $pipe; do
	pid=${data%%:*} && data=${data#$pid:}
	login=${data%%:*}
	message=${data#$login:}

	for pi in *.fifo
	do
		if [[ "$pi" != "$pipe" ]]; 
		then
			echo "$login> $message" > "$pi"
		fi
	done
done

