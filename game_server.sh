#!/bin/bash

pipe='server.fifo'
rm -f $pipe
mkfifo $pipe

nc -lk -p $1 -e distributor.sh &

echo "server started on $1"

while read data < $pipe; do
	for pi in *.pipe; do
		if [[ "$pi" != "$pipe" ]]; then
			echo $data > pi
		fi
	done
done

