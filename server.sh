#!/bin/bash

pipe='server.fifo'
rm -f *.fifo
mkfifo $pipe

coproc distributor { while true; do nc -lk -p $1 -e distributor.sh; done; }
echo "server started on $1"

function check_last_client {
	count=$(ls *.fifo | wc -l)
	if [[ $count -eq 1 ]]; 
	then
		kill $distributor_PID
		rm -f *.fifo
		exit 0
	fi
}

while read data < $pipe; do
	pid=${data%%:*} && data=${data#$pid:}
	login=${data%%:*}
	message=${data#$login:}
	
	if [[ $message == 'exit' ]];
	then 
		check_last_client
	fi

	for pi in *.fifo
	do
		if [[ "$pi" != "$pipe" && "$pi" != "$pid.fifo" ]]; 
		then
			echo -e "\e[32m$login\e[0m $message" > "$pi"
		fi
	done

done

